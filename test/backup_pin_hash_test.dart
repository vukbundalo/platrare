import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/data_transfer.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The app-lock PIN verifier is a PBKDF2 hash of a short numeric PIN, which is
/// brute-forced offline in seconds. It must never appear in an unencrypted
/// backup (the daily auto-backup is a plain zip in Documents).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Map<String, dynamic> dataJsonOf(List<int> zipBytes) {
    final archive = ZipDecoder().decodeBytes(zipBytes);
    final entry = archive.files.firstWhere((f) => f.name == 'data.json');
    return jsonDecode(utf8.decode(entry.content as List<int>))
        as Map<String, dynamic>;
  }

  test('auto-backup keeps the lock flag but never the PIN verifier', () async {
    SharedPreferences.setMockInitialValues({
      'security_enabled': true,
      'security_pin_hash': 'pbkdf2\$100000\$c2FsdA==\$aGFzaA==',
    });

    final bytes = await DataTransfer.buildAutoBackupBytes();
    final prefs = dataJsonOf(bytes)['preferences'] as Map<String, dynamic>;

    expect(prefs['securityEnabled'], isTrue);
    expect(prefs.containsKey('pinHash'), isFalse);
  });
}
