import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kSecurityEnabledKey = 'security_enabled';
const _kSecurityPinHashKey = 'security_pin_hash';

final ValueNotifier<bool> appSecurityEnabled = ValueNotifier(false);

Future<void> initSecurityPrefs() async {
  final p = await SharedPreferences.getInstance();
  appSecurityEnabled.value = p.getBool(_kSecurityEnabledKey) ?? false;
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
