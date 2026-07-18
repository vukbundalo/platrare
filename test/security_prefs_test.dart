import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/security_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _pinHashKey = 'security_pin_hash';
const _failedAttemptsKey = 'security_pin_failed_attempts';
const _lockoutUntilKey = 'security_pin_lockout_until_ms';

String legacySha256(String pin) => sha256.convert(utf8.encode(pin)).toString();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('save + verify round-trip uses salted PBKDF2 format', () async {
    await saveSecurityPin('4711');

    final p = await SharedPreferences.getInstance();
    final stored = p.getString(_pinHashKey)!;
    expect(stored, startsWith('pbkdf2\$$kPinPbkdf2Iterations\$'));

    expect(await verifySecurityPin('4711'), isTrue);
    expect(await verifySecurityPin('4712'), isFalse);

    // Same PIN saved twice yields different verifiers (random salt).
    await saveSecurityPin('4711');
    final stored2 = (await SharedPreferences.getInstance())
        .getString(_pinHashKey)!;
    expect(stored2, isNot(stored));
    expect(await verifySecurityPin('4711'), isTrue);
  });

  test('legacy unsalted SHA-256 hash verifies and is upgraded', () async {
    SharedPreferences.setMockInitialValues({
      _pinHashKey: legacySha256('1234'),
    });

    expect(await verifySecurityPin('9999'), isFalse);
    expect(await verifySecurityPin('1234'), isTrue);

    // Successful entry migrates the stored value to the salted format.
    final stored =
        (await SharedPreferences.getInstance()).getString(_pinHashKey)!;
    expect(stored, startsWith('pbkdf2\$'));
    expect(await verifySecurityPin('1234'), isTrue);
    expect(await verifySecurityPin('9999'), isFalse);
  });

  test('lockout starts after repeated failures and blocks the correct PIN',
      () async {
    SharedPreferences.setMockInitialValues({
      _pinHashKey: legacySha256('1234'),
    });

    for (var i = 1; i < kPinMaxAttemptsBeforeLockout; i++) {
      final r = await attemptPinUnlock('0000');
      expect(r.ok, isFalse, reason: 'attempt $i');
      expect(r.isLockedOut, isFalse, reason: 'attempt $i');
    }

    final locked = await attemptPinUnlock('0000');
    expect(locked.isLockedOut, isTrue);
    expect(locked.lockoutRemainingSeconds, 30);

    // Even the correct PIN is refused while locked out.
    final duringLockout = await attemptPinUnlock('1234');
    expect(duringLockout.isLockedOut, isTrue);
    expect(await pinLockoutRemainingSeconds(), greaterThan(0));
  });

  test('lockout window doubles on continued failures and success resets',
      () async {
    SharedPreferences.setMockInitialValues({
      _pinHashKey: legacySha256('1234'),
      _failedAttemptsKey: kPinMaxAttemptsBeforeLockout,
      // Expired lockout: attempts are allowed again.
      _lockoutUntilKey: DateTime.now().millisecondsSinceEpoch - 1000,
    });

    final r = await attemptPinUnlock('0000');
    expect(r.isLockedOut, isTrue);
    expect(r.lockoutRemainingSeconds, 60);

    // Clear the lockout window, then unlock correctly — counters reset.
    final p = await SharedPreferences.getInstance();
    await p.setInt(
        _lockoutUntilKey, DateTime.now().millisecondsSinceEpoch - 1000);
    final ok = await attemptPinUnlock('1234');
    expect(ok.ok, isTrue);
    expect(p.getInt(_failedAttemptsKey), isNull);
    expect(p.getInt(_lockoutUntilKey), isNull);
    expect(await pinLockoutRemainingSeconds(), 0);
  });

  test('restoreSecurityPinHash accepts both formats and resets throttling',
      () async {
    SharedPreferences.setMockInitialValues({
      _failedAttemptsKey: 3,
      _lockoutUntilKey: DateTime.now().millisecondsSinceEpoch + 60000,
    });

    // Legacy hash from an old backup.
    await restoreSecurityPinHash(legacySha256('1234'));
    expect(await pinLockoutRemainingSeconds(), 0);
    expect(await verifySecurityPin('1234'), isTrue);

    // Current-format hash from a new backup.
    await saveSecurityPin('8642');
    final current =
        (await SharedPreferences.getInstance()).getString(_pinHashKey)!;
    SharedPreferences.setMockInitialValues({});
    await restoreSecurityPinHash(current);
    expect(await verifySecurityPin('8642'), isTrue);
    expect(await verifySecurityPin('1234'), isFalse);
  });
}
