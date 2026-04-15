import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kSecurityEnabledKey = 'security_enabled';
const _kSecurityPinHashKey = 'security_pin_hash';
const _kLockGraceSecondsKey = 'security_lock_grace_seconds';

final ValueNotifier<bool> appSecurityEnabled = ValueNotifier(false);

/// Seconds the app may stay in the background before re-lock (0 = lock on pause).
final ValueNotifier<int> appLockGraceSeconds = ValueNotifier(0);

/// Supported re-lock delay values (seconds).
const List<int> kAppLockGraceOptions = [0, 30, 60, 300];

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

String _hashPin(String pin) {
  final bytes = utf8.encode(pin);
  return sha256.convert(bytes).toString();
}

Future<void> saveSecurityPin(String pin) async {
  final p = await SharedPreferences.getInstance();
  await p.setString(_kSecurityPinHashKey, _hashPin(pin));
}

Future<void> clearSecurityPin() async {
  final p = await SharedPreferences.getInstance();
  await p.remove(_kSecurityPinHashKey);
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
  return _hashPin(pin) == storedHash;
}

/// Returns the raw security backup payload for inclusion in a backup file.
Future<({bool enabled, String? pinHash})> getSecurityBackup() async {
  final p = await SharedPreferences.getInstance();
  return (
    enabled: p.getBool(_kSecurityEnabledKey) ?? false,
    pinHash: p.getString(_kSecurityPinHashKey),
  );
}

/// Restores a previously backed-up PIN hash directly, bypassing re-hashing.
/// Used only during backup import — never for user PIN entry.
Future<void> restoreSecurityPinHash(String hash) async {
  final p = await SharedPreferences.getInstance();
  await p.setString(_kSecurityPinHashKey, hash);
}
