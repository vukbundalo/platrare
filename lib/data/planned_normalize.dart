import '../models/planned_transaction.dart';

/// Fills id / account id fields from live accounts so rows are DB-exportable.
class PlannedNormalizer {
  PlannedNormalizer._();

  static PlannedTransaction normalize(PlannedTransaction p, {bool isUpdate = false}) {
    final now = DateTime.now();
    return PlannedTransaction(
      id: p.id,
      nativeAmount: p.nativeAmount,
      currencyCode: p.currencyCode,
      destinationAmount: p.destinationAmount,
      fromAccount: p.fromAccount,
      toAccount: p.toAccount,
      fromAccountId: p.fromAccount?.id ?? p.fromAccountId,
      toAccountId: p.toAccount?.id ?? p.toAccountId,
      category: p.category,
      description: p.description,
      date: p.date,
      txType: p.txType,
      repeatInterval: p.repeatInterval,
      repeatEvery: p.repeatEvery,
      repeatDayOfMonth: p.repeatDayOfMonth,
      weekendAdjustment: p.weekendAdjustment,
      repeatEndDate: p.repeatEndDate,
      repeatEndAfter: p.repeatEndAfter,
      repeatConfirmedCount: p.repeatConfirmedCount,
      createdAt: p.createdAt,
      updatedAt: isUpdate ? now : p.updatedAt,
      attachments: List<String>.from(p.attachments),
    );
  }
}
