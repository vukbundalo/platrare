import 'dummy_transactions.dart';
import 'package:platrare/models/transaction_item.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/enums.dart';

List<TransactionItem> dummyRealized =
    dummyTransactions.map((tx) {
      // 1) Determine type by sign
      final txnType =
          tx.amount < 0 ? TransactionType.expense : TransactionType.income;

      // 2) Only partnerTransfer/transfer ever have a fromAccount
      final Account? from =
          (txnType == TransactionType.partnerTransfer ||
                  txnType == TransactionType.transfer)
              ? tx.fromAccount
              : null;

      // 3) The “toAccount” is your old tx.account
      final Account to = tx.toAccount;

      return TransactionItem(
        title: tx.title,
        date: tx.date,
        type: txnType,
        fromAccount: from,
        toAccount: to,
        amount: tx.amount,
      );
    }).toList();