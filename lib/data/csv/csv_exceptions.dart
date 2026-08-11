/// Typed CSV import failures, mirroring the sealed `BackupException` hierarchy
/// in `backup_exceptions.dart` so the settings screen can map each one to its
/// own localized message.
sealed class CsvImportException implements Exception {
  const CsvImportException();
}

/// The file has no header row we recognise, so we cannot tell which column is
/// which.
class CsvNoRecognisedColumnsException extends CsvImportException {
  const CsvNoRecognisedColumnsException();
}

/// A header row exists but is missing `date` or `amount`, both of which are
/// required to build a transaction.
class CsvMissingRequiredColumnException extends CsvImportException {
  const CsvMissingRequiredColumnException(this.column);

  /// Canonical name of the missing column, e.g. `date`.
  final String column;
}

/// The file parsed but contained no usable data rows.
class CsvEmptyException extends CsvImportException {
  const CsvEmptyException();
}

/// Guard rail against pathological files: [maxRows] data rows is the ceiling.
class CsvTooManyRowsException extends CsvImportException {
  const CsvTooManyRowsException(this.rows, this.maxRows);

  final int rows;
  final int maxRows;
}
