import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/transaction_normalize.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction.dart';

void main() {
  group('TransactionNormalizer', () {
    test('copies account ids and snapshots from live accounts', () {
      final from = Account(
        name: 'Cash',
        group: AccountGroup.personal,
        currencyCode: 'BAM',
      );
      final to = Account(
        name: 'Savings',
        group: AccountGroup.personal,
        currencyCode: 'EUR',
      );
      final t = Transaction(
        nativeAmount: 10,
        currencyCode: 'BAM',
        fromAccount: from,
        toAccount: to,
      );
      final n = TransactionNormalizer.normalize(t);
      expect(n.fromAccountId, from.id);
      expect(n.toAccountId, to.id);
      expect(n.fromSnapshotName, 'Cash');
      expect(n.toSnapshotName, 'Savings');
      expect(n.fromSnapshotCurrency, 'BAM');
      expect(n.toSnapshotCurrency, 'EUR');
    });

    test('isUpdate sets updatedAt', () {
      final t = Transaction(nativeAmount: 1, currencyCode: 'BAM');
      final n = TransactionNormalizer.normalize(t, isUpdate: true);
      expect(n.updatedAt, isNotNull);
    });
  });
}
