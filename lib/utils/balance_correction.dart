import '../data/balance_posting.dart' as bp;
import '../data/data_repository.dart';
import '../models/account.dart';

export '../data/balance_posting.dart' show BalanceCorrectionResult;

/// UI-facing helper: posts a balance correction via [DataRepository].
Future<bp.BalanceCorrectionResult> applyLedgerBalanceCorrection({
  required Account account,
  required double previousBookBalance,
  required double newBookBalance,
  String category = '__balance_adjustment__',
  String description = '__balance_correction__',
}) =>
    bp.applyLedgerBalanceCorrection(
      account: account,
      previousBookBalance: previousBookBalance,
      newBookBalance: newBookBalance,
      category: category,
      description: description,
      persistTransaction: DataRepository.addTransaction,
    );
