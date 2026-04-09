import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart' as crypto;

import 'backup_exceptions.dart';
import 'backup_format.dart';

/// Cleartext JSON header after magic + version (fields stored as Base64 for binary blobs).
class EncryptedOuterHeader {
  EncryptedOuterHeader({
    required this.salt,
    required this.iterations,
    required this.nonce,
    required this.innerSha256Hex,
  });

  final Uint8List salt;
  final int iterations;
  final Uint8List nonce;
  final String innerSha256Hex;

  Map<String, dynamic> toJson() => {
        'salt': base64Encode(salt),
        'iterations': iterations,
        'nonce': base64Encode(nonce),
        'innerSha256': innerSha256Hex,
      };

  static EncryptedOuterHeader fromJson(Map<String, dynamic> j) {
    final saltB64 = j['salt'] as String?;
    final nonceB64 = j['nonce'] as String?;
    final inner = j['innerSha256'] as String?;
    final iter = j['iterations'];
    if (saltB64 == null || nonceB64 == null || inner == null || iter is! int) {
      throw const BackupCorruptFileException();
    }
    return EncryptedOuterHeader(
      salt: Uint8List.fromList(base64Decode(saltB64)),
      iterations: iter,
      nonce: Uint8List.fromList(base64Decode(nonceB64)),
      innerSha256Hex: inner,
    );
  }
}

Uint8List _randomBytes(int n) {
  final r = Random.secure();
  final out = Uint8List(n);
  for (var i = 0; i < n; i++) {
    out[i] = r.nextInt(256);
  }
  return out;
}

String _sha256Hex(Uint8List data) =>
    crypto.sha256.convert(data).toString();

/// Wraps inner ZIP bytes as `.platrare` (magic + header + AES-256-GCM ciphertext + tag).
Future<Uint8List> encryptInnerZip({
  required Uint8List innerZip,
  required String password,
}) async {
  final innerSha = _sha256Hex(innerZip);
  final salt = _randomBytes(16);
  final aes = AesGcm.with256bits();
  final nonce = _randomBytes(aes.nonceLength);

  final pbkdf2 = Pbkdf2.hmacSha256(
    iterations: kPbkdf2Iterations,
    bits: 256,
  );
  final key = await pbkdf2.deriveKeyFromPassword(
    password: password,
    nonce: salt,
  );

  final box = await aes.encrypt(
    innerZip,
    secretKey: key,
    nonce: nonce,
  );

  final header = EncryptedOuterHeader(
    salt: salt,
    iterations: kPbkdf2Iterations,
    nonce: Uint8List.fromList(box.nonce),
    innerSha256Hex: innerSha,
  );
  final headerJson = utf8.encode(jsonEncode(header.toJson()));
  final out = BytesBuilder(copy: false);
  out.add(kEncryptedMagic);
  out.addByte(kOuterFormatVersion);
  final len = headerJson.length;
  out.addByte(len & 0xff);
  out.addByte((len >> 8) & 0xff);
  out.addByte((len >> 16) & 0xff);
  out.addByte((len >> 24) & 0xff);
  out.add(headerJson);
  out.add(box.cipherText);
  out.add(box.mac.bytes);
  return out.toBytes();
}

/// Decrypts `.platrare` bytes to inner ZIP; verifies [EncryptedOuterHeader.innerSha256Hex].
Future<Uint8List> decryptToInnerZip({
  required Uint8List fileBytes,
  required String password,
}) async {
  if (!looksLikeEncryptedPlatrare(fileBytes)) {
    throw const BackupCorruptFileException();
  }
  if (fileBytes.length < 9) throw const BackupCorruptFileException();
  final ver = fileBytes[4];
  if (ver != kOuterFormatVersion) {
    throw const BackupUnsupportedSchemaException();
  }
  final jsonLen = fileBytes[5] |
      (fileBytes[6] << 8) |
      (fileBytes[7] << 16) |
      (fileBytes[8] << 24);
  final headerEnd = 9 + jsonLen;
  if (fileBytes.length < headerEnd) throw const BackupCorruptFileException();

  Map<String, dynamic> headerMap;
  try {
    headerMap =
        jsonDecode(utf8.decode(fileBytes.sublist(9, headerEnd))) as Map<String, dynamic>;
  } catch (_) {
    throw const BackupCorruptFileException();
  }
  final header = EncryptedOuterHeader.fromJson(headerMap);

  final pbkdf2 = Pbkdf2.hmacSha256(
    iterations: header.iterations,
    bits: 256,
  );
  final key = await pbkdf2.deriveKeyFromPassword(
    password: password,
    nonce: header.salt,
  );

  final aes = AesGcm.with256bits();
  final macLen = aes.macAlgorithm.macLength;
  final body = fileBytes.sublist(headerEnd);
  if (body.length < macLen) throw const BackupCorruptFileException();
  final ctLen = body.length - macLen;
  final cipherText = body.sublist(0, ctLen);
  final macBytes = body.sublist(ctLen);

  final box = SecretBox(
    cipherText,
    nonce: header.nonce,
    mac: Mac(macBytes),
  );

  late final Uint8List innerZip;
  try {
    innerZip = Uint8List.fromList(await aes.decrypt(box, secretKey: key));
  } on SecretBoxAuthenticationError {
    throw const BackupWrongPasswordException();
  } catch (_) {
    throw const BackupCorruptFileException();
  }

  if (_sha256Hex(innerZip) != header.innerSha256Hex) {
    throw const BackupChecksumMismatchException();
  }
  return innerZip;
}
