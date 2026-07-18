import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kSecurityEnabledKey = 'security_enabled';
const _kSecurityPinHashKey = 'security_pin_hash';
const _kLockGraceSecondsKey = 'security_lock_grace_seconds';
const _kPinFailedAttemptsKey = 'security_pin_failed_attempts';
const _kPinLockoutUntilMsKey = 'security_pin_lockout_until_ms';

final ValueNotifier<bool> appSecurityEnabled = ValueNotifier(false);

/// Seconds the app may stay in the background before re-lock (0 = lock on pause).
final ValueNotifier<int> appLockGraceSeconds = ValueNotifier(0);

/// Supported re-lock delay values (seconds).
const List<int> kAppLockGraceOptions = [0, 30, 60, 300];

/// PBKDF2-HMAC-SHA256 cost for the app-lock PIN. A short numeric PIN has a
/// tiny keyspace, so the stored verifier must be slow to grind offline.
const int kPinPbkdf2Iterations = 100000;
const String _kPinHashPrefix = 'pbkdf2';

/// Consecutive failures allowed before lockouts start.
const int kPinMaxAttemptsBeforeLockout = 5;
const int _kPinBaseLockoutSeconds = 30;
const int _kPinMaxLockoutSeconds = 300;

Future<void> initSecurityPrefs() async {
  final p = await SharedPreferences.getInstance();
  appSecurityEnabled.value = p.getBool(_kSecurityEnabledKey) ?? false;
  final raw = p.getInt(_kLockGraceSecondsKey);
  appLockGraceSeconds.value =
      raw != null && kAppLockGraceOptions.contains(raw) ? raw : 0;
}

Future<void> setLockGraceSeconds(int seconds) async {
  final v = kAppLockGraceOptions.contains(seconds) ? seconds : 0;
  final p = await SharedPreferences.getInstance();
  appLockGraceSeconds.value = v;
  await p.setInt(_kLockGraceSecondsKey, v);
}

Future<void> clearLockGracePreference() async {
  final p = await SharedPreferences.getInstance();
  appLockGraceSeconds.value = 0;
  await p.remove(_kLockGraceSecondsKey);
}

Future<void> setSecurityEnabled(bool enabled) async {
  final p = await SharedPreferences.getInstance();
  appSecurityEnabled.value = enabled;
  await p.setBool(_kSecurityEnabledKey, enabled);
}

Uint8List _randomBytes(int n) {
  final r = Random.secure();
  final out = Uint8List(n);
  for (var i = 0; i < n; i++) {
    out[i] = r.nextInt(256);
  }
  return out;
}

bool _constantTimeEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a[i] ^ b[i];
  }
  return diff == 0;
}

Future<List<int>> _derivePinKey(
  String pin,
  List<int> salt,
  int iterations,
) async {
  final pbkdf2 = Pbkdf2.hmacSha256(iterations: iterations, bits: 256);
  final key = await pbkdf2.deriveKeyFromPassword(password: pin, nonce: salt);
  return key.extractBytes();
}

/// Stored as `pbkdf2$<iterations>$<saltB64>$<hashB64>`.
Future<String> _hashPin(String pin) async {
  final salt = _randomBytes(16);
  final bytes = await _derivePinKey(pin, salt, kPinPbkdf2Iterations);
  return '$_kPinHashPrefix\$$kPinPbkdf2Iterations'
      '\$${base64Encode(salt)}\$${base64Encode(bytes)}';
}

/// Pre-1.0 releases stored an unsalted SHA-256 hex digest.
bool _isLegacyPinHash(String stored) =>
    RegExp(r'^[0-9a-f]{64}$').hasMatch(stored);

String _legacyHashPin(String pin) =>
    sha256.convert(utf8.encode(pin)).toString();

Future<bool> _matchesStoredHash(String pin, String stored) async {
  if (_isLegacyPinHash(stored)) {
    return _constantTimeEquals(
      utf8.encode(_legacyHashPin(pin)),
      utf8.encode(stored),
    );
  }
  final parts = stored.split(r'$');
  if (parts.length != 4 || parts[0] != _kPinHashPrefix) return false;
  final iterations = int.tryParse(parts[1]);
  if (iterations == null || iterations < 1) return false;
  final Uint8List salt;
  final Uint8List expected;
  try {
    salt = base64Decode(parts[2]);
    expected = base64Decode(parts[3]);
  } catch (_) {
    return false;
  }
  final derived = await _derivePinKey(pin, salt, iterations);
  return _constantTimeEquals(derived, expected);
}

Future<void> saveSecurityPin(String pin) async {
  final p = await SharedPreferences.getInstance();
  await p.setString(_kSecurityPinHashKey, await _hashPin(pin));
  await _resetPinThrottle(p);
}

Future<void> clearSecurityPin() async {
  final p = await SharedPreferences.getInstance();
  await p.remove(_kSecurityPinHashKey);
  await _resetPinThrottle(p);
}

Future<bool> hasSecurityPin() async {
  final p = await SharedPreferences.getInstance();
  final hash = p.getString(_kSecurityPinHashKey);
  return hash != null && hash.isNotEmpty;
}

Future<bool> verifySecurityPin(String pin) async {
  final p = await SharedPreferences.getInstance();
  final storedHash = p.getString(_kSecurityPinHashKey);
  if (storedHash == null || storedHash.isEmpty) return false;
  final ok = await _matchesStoredHash(pin, storedHash);
  // Transparently upgrade legacy unsalted hashes on successful entry.
  if (ok && _isLegacyPinHash(storedHash)) {
    await p.setString(_kSecurityPinHashKey, await _hashPin(pin));
  }
  return ok;
}

// ─── PIN attempt throttling ──────────────────────────────────────────────────

class PinUnlockResult {
  const PinUnlockResult.ok()
      : ok = true,
        lockoutRemainingSeconds = 0;
  const PinUnlockResult.wrongPin()
      : ok = false,
        lockoutRemainingSeconds = 0;
  const PinUnlockResult.lockedOut(this.lockoutRemainingSeconds) : ok = false;

  final bool ok;

  /// > 0 when further attempts are refused until the lockout expires.
  final int lockoutRemainingSeconds;

  bool get isLockedOut => lockoutRemainingSeconds > 0;
}

int _lockoutRemainingSeconds(SharedPreferences p) {
  final until = p.getInt(_kPinLockoutUntilMsKey);
  if (until == null) return 0;
  final ms = until - DateTime.now().millisecondsSinceEpoch;
  return ms <= 0 ? 0 : (ms / 1000).ceil();
}

/// Remaining lockout, for showing a countdown before any attempt is made.
Future<int> pinLockoutRemainingSeconds() async {
  final p = await SharedPreferences.getInstance();
  return _lockoutRemainingSeconds(p);
}

Future<void> _resetPinThrottle(SharedPreferences p) async {
  await p.remove(_kPinFailedAttemptsKey);
  await p.remove(_kPinLockoutUntilMsKey);
}

/// Verifies [pin] with persistent failure counting: after
/// [kPinMaxAttemptsBeforeLockout] consecutive failures, attempts are refused
/// for an exponentially growing window (30 s doubling up to 5 min).
Future<PinUnlockResult> attemptPinUnlock(String pin) async {
  final p = await SharedPreferences.getInstance();
  final remaining = _lockoutRemainingSeconds(p);
  if (remaining > 0) return PinUnlockResult.lockedOut(remaining);

  if (await verifySecurityPin(pin)) {
    await _resetPinThrottle(p);
    return const PinUnlockResult.ok();
  }

  final attempts = (p.getInt(_kPinFailedAttemptsKey) ?? 0) + 1;
  await p.setInt(_kPinFailedAttemptsKey, attempts);
  if (attempts >= kPinMaxAttemptsBeforeLockout) {
    final doublings = min(attempts - kPinMaxAttemptsBeforeLockout, 8);
    final seconds =
        min(_kPinBaseLockoutSeconds * (1 << doublings), _kPinMaxLockoutSeconds);
    await p.setInt(
      _kPinLockoutUntilMsKey,
      DateTime.now().millisecondsSinceEpoch + seconds * 1000,
    );
    return PinUnlockResult.lockedOut(seconds);
  }
  return const PinUnlockResult.wrongPin();
}

// ─── Backup integration ──────────────────────────────────────────────────────

/// Returns the raw security backup payload for inclusion in a backup file.
Future<({bool enabled, String? pinHash})> getSecurityBackup() async {
  final p = await SharedPreferences.getInstance();
  return (
    enabled: p.getBool(_kSecurityEnabledKey) ?? false,
    pinHash: p.getString(_kSecurityPinHashKey),
  );
}

/// Restores a previously backed-up PIN hash directly, bypassing re-hashing.
/// Used only during backup import — never for user PIN entry. Accepts both
/// the current `pbkdf2$…` format and the legacy SHA-256 hex format (the
/// latter is upgraded on the next successful unlock).
Future<void> restoreSecurityPinHash(String hash) async {
  final p = await SharedPreferences.getInstance();
  await p.setString(_kSecurityPinHashKey, hash);
  await _resetPinThrottle(p);
}
