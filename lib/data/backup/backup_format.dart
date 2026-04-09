// Canonical backup container (inner ZIP + optional encrypted outer wrapper).
import 'dart:typed_data';

/// Magic bytes for encrypted `.platrare` files: ASCII "PLTR".
const List<int> kEncryptedMagic = [0x50, 0x4c, 0x54, 0x52];

/// Outer wrapper format version (byte after magic).
const int kOuterFormatVersion = 1;

/// Inner backup schema (manifest + data.json layout).
const int kInnerSchemaVersion = 1;

const String kDataJsonFileName = 'data.json';
const String kManifestFileName = 'manifest.json';
const String kAttachmentsFolder = 'attachments';

const String kAttachmentLayoutBundled = 'bundled';

/// PBKDF2 iteration count (HMAC-SHA256).
const int kPbkdf2Iterations = 210000;

bool looksLikeZip(Uint8List bytes) =>
    bytes.length >= 4 && bytes[0] == 0x50 && bytes[1] == 0x4b;

bool looksLikeEncryptedPlatrare(Uint8List bytes) =>
    bytes.length >= kEncryptedMagic.length &&
    bytes[0] == kEncryptedMagic[0] &&
    bytes[1] == kEncryptedMagic[1] &&
    bytes[2] == kEncryptedMagic[2] &&
    bytes[3] == kEncryptedMagic[3];
