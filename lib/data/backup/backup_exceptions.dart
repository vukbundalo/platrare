/// Typed failures for backup import/export (map to l10n in UI).
sealed class BackupException implements Exception {
  const BackupException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BackupWrongPasswordException extends BackupException {
  const BackupWrongPasswordException([super.message = 'Wrong password.']);
}

class BackupCorruptFileException extends BackupException {
  const BackupCorruptFileException([super.message = 'Corrupt or invalid backup file.']);
}

class BackupChecksumMismatchException extends BackupException {
  const BackupChecksumMismatchException([super.message = 'Checksum mismatch.']);
}

class BackupUnsupportedSchemaException extends BackupException {
  const BackupUnsupportedSchemaException([super.message = 'Unsupported backup version.']);
}

/// Encrypted backup selected but no password was supplied.
class BackupPasswordRequiredException extends BackupException {
  const BackupPasswordRequiredException(
      [super.message = 'Password is required for this backup.']);
}
