import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/app_data.dart' as data;
import 'package:platrare/data/app_signals.dart';
import 'package:platrare/data/data_repository.dart';
import 'package:platrare/data/ledger_service.dart';
import 'package:platrare/data/local/platrare_database.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PlatrareDatabase db;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = PlatrareDatabase(NativeDatabase.memory());
    PlatrareDatabase.useForTesting(db);
    data.accounts.clear();
    data.transactions.clear();
    data.plannedTransactions.clear();
  });
  tearDown(() => db.close());

  test('every ledger mutation and a full reload bump ledgerRevision', () async {
    var seen = 0;
    void listener() => seen++;
    ledgerRevision.addListener(listener);
    addTearDown(() => ledgerRevision.removeListener(listener));

    final a = Account(name: 'Cash', currencyCode: 'EUR');
    await DataRepository.addAccount(a);
    expect(seen, 1);

    await LedgerService.post(Transaction(
      nativeAmount: 5,
      currencyCode: 'EUR',
      fromAccount: a,
      txType: TxType.expense,
    ));
    expect(seen, 2);

    await DataRepository.addCategory('Books', income: false);
    expect(seen, 3);

    await db.loadIntoMemory();
    expect(seen, 4);
  });
}
