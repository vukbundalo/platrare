import '../models/transaction.dart';

/// Fills id/snapshot fields from live accounts so rows are DB-exportable and
/// remain interpretable if accounts are removed later.
class TransactionNormalizer {
  TransactionNormalizer._();

  static Transaction normalize(Transaction t, {bool isUpdate = false}) {
    final now = DateTime.now();
    return Transaction(
      id: t.id,
      nativeAmount: t.nativeAmount,
      currencyCode: t.currencyCode,
      baseAmount: t.baseAmount,
      exchangeRate: t.exchangeRate,
      destinationAmount: t.destinationAmount,
      fromAccount: t.fromAccount,
      toAccount: t.toAccount,
      category: t.category,
      description: t.description,
      date: t.date,
      txType: t.txType,
      attachments: List<String>.from(t.attachments),
      createdAt: t.createdAt,
      updatedAt: isUpdate ? now : t.updatedAt,
      fromAccountId: t.fromAccount?.id ?? t.fromAccountId,
      toAccountId: t.toAccount?.id ?? t.toAccountId,
      fromSnapshotName:
          t.fromAccount != null ? t.fromAccount!.name : t.fromSnapshotName,
      fromSnapshotCurrency: t.fromAccount != null
          ? t.fromAccount!.currencyCode
          : t.fromSnapshotCurrency,
      toSnapshotName:
          t.toAccount != null ? t.toAccount!.name : t.toSnapshotName,
      toSnapshotCurrency: t.toAccount != null
          ? t.toAccount!.currencyCode
          : t.toSnapshotCurrency,
    );
  }
}
