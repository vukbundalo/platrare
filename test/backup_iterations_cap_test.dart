import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/backup/backup_crypto.dart';
import 'package:platrare/data/backup/backup_exceptions.dart';
import 'package:platrare/data/backup/backup_format.dart';

/// Rewrites the cleartext JSON header of an encrypted backup with a different
/// iteration count, keeping the layout: 'PLTR' + version + LE u32 length +
/// header JSON + ciphertext.
Uint8List _withIterations(Uint8List file, int iterations) {
  final len = ByteData.sublistView(file, 5, 9).getUint32(0, Endian.little);
  final headerEnd = 9 + len;
  final header =
      jsonDecode(utf8.decode(file.sublist(9, headerEnd))) as Map<String, dynamic>;
  header['iterations'] = iterations;
  final newHeader = utf8.encode(jsonEncode(header));
  final out = BytesBuilder()
    ..add(file.sublist(0, 5))
    ..add((ByteData(4)..setUint32(0, newHeader.length, Endian.little))
        .buffer
        .asUint8List())
    ..add(newHeader)
    ..add(file.sublist(headerEnd));
  return out.toBytes();
}

void main() {
  test('import rejects an iteration count outside the accepted band', () async {
    final inner = Uint8List.fromList(List<int>.generate(64, (i) => i));
    final file = await encryptInnerZip(innerZip: inner, password: 'correct horse');

    // Sanity: the untouched file still decrypts.
    expect(await decryptToInnerZip(fileBytes: file, password: 'correct horse'),
        inner);

    await expectLater(
      decryptToInnerZip(
        fileBytes: _withIterations(file, kPbkdf2MaxIterations + 1),
        password: 'correct horse',
      ),
      throwsA(isA<BackupCorruptFileException>()),
    );
    await expectLater(
      decryptToInnerZip(
        fileBytes: _withIterations(file, 1),
        password: 'correct horse',
      ),
      throwsA(isA<BackupCorruptFileException>()),
    );
  });
}
