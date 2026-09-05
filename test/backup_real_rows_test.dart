import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:platrare/data/app_data.dart' as data;
import 'package:platrare/data/data_transfer.dart';
import 'package:platrare/data/user_settings.dart' as settings;
import 'package:platrare/models/account.dart';
import 'package:platrare/models/planned_transaction.dart';
import 'package:platrare/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class _TestPathProvider extends PathProviderPlatform {
  _TestPathProvider(this._root);
  final String _root;
  @override
  Future<String?> getApplicationDocumentsPath() async => _root;
  @override
  Future<String?> getTemporaryPath() async => _root;
}

/// Encodes a realistic ledger into a backup and decodes it again: accounts in
/// two groups and currencies, a cross-currency transfer with a locked rate,
/// a categorised expense with snapshot names, and a capped monthly plan.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PathProviderPlatform original;
  setUpAll(() {
    original = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _TestPathProvider(
        Directory.systemTemp.createTempSync('platrare_rows_test').path);
  });
  tearDownAll(() => PathProviderPlatform.instance = original);

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    data.accounts.clear();
    data.transactions.clear();
    data.plannedTransactions.clear();
    data.incomeCategories.clear();
    data.expenseCategories.clear();
  });

  test('accounts, transactions and planned rows survive a round trip', () async {
    settings.baseCurrency = 'EUR';
    settings.secondaryCurrency = 'USD';
    final bank = Account(
      id: 'acc-bank',
      name: 'Bank',
      institution: 'Raiffeisen',
      group: AccountGroup.personal,
      currencyCode: 'EUR',
      balance: 980.25,
      overdraftLimit: 500,
      iconCodePoint: 0xe0af,
      colorArgb: 0xFF2F7DD1,
      sortOrder: 0,
      createdAt: DateTime(2026, 1, 2, 10, 30),
    );
    final ana = Account(
      id: 'acc-ana',
      name: 'Ana',
      group: AccountGroup.individuals,
      currencyCode: 'USD',
      balance: -120,
      archived: false,
      sortOrder: 1,
      createdAt: DateTime(2026, 1, 3),
    );
    data.accounts.addAll([bank, ana]);
    data.incomeCategories.addAll(['Salary']);
    data.expenseCategories.addAll(['Groceries', 'Gifts']);

    final expense = Transaction(
      id: 'tx-groceries',
      nativeAmount: 19.75,
      currencyCode: 'EUR',
      baseAmount: 19.75,
      exchangeRate: 1,
      fromAccount: bank,
      category: 'Groceries',
      description: 'Market',
      date: DateTime(2026, 8, 30, 18, 5),
      txType: TxType.expense,
      createdAt: DateTime(2026, 8, 30, 18, 6),
      fromSnapshotName: 'Bank',
      fromSnapshotCurrency: 'EUR',
    );
    final advance = Transaction(
      id: 'tx-advance',
      nativeAmount: 100,
      currencyCode: 'EUR',
      baseAmount: 100,
      exchangeRate: 1,
      destinationAmount: 108.4,
      fromAccount: bank,
      toAccount: ana,
      category: 'Gifts',
      date: DateTime(2026, 9, 1, 9),
      txType: TxType.advance,
      createdAt: DateTime(2026, 9, 1, 9, 1),
      updatedAt: DateTime(2026, 9, 2),
      fromSnapshotName: 'Bank',
      fromSnapshotCurrency: 'EUR',
      toSnapshotName: 'Ana',
      toSnapshotCurrency: 'USD',
    );
    data.transactions.addAll([advance, expense]);

    final rent = PlannedTransaction(
      id: 'pl-rent',
      nativeAmount: 650,
      currencyCode: 'EUR',
      fromAccount: bank,
      category: 'Groceries',
      description: 'Rent',
      date: DateTime(2026, 10, 1),
      txType: TxType.expense,
      repeatInterval: RepeatInterval.monthly,
      repeatEvery: 1,
      repeatDayOfMonth: 1,
      weekendAdjustment: WeekendAdjustment.previousFriday,
      repeatEndAfter: 12,
      repeatConfirmedCount: 2,
      createdAt: DateTime(2026, 9, 1),
    );
    data.plannedTransactions.add(rent);

    final bytes = await DataTransfer.buildAutoBackupBytes();
    final prepared = await DataTransfer.prepareImport(bytes);
    final b = prepared.data;

    expect(b.baseCurrency, 'EUR');
    expect(b.secondaryCurrency, 'USD');
    expect(b.securityEnabled, isFalse);
    expect(b.pinHash, isNull);
    expect(b.incomeCategories, ['Salary']);
    expect(b.expenseCategories, ['Groceries', 'Gifts']);

    final bank2 = b.accounts.singleWhere((a) => a.id == 'acc-bank');
    expect(bank2.name, 'Bank');
    expect(bank2.institution, 'Raiffeisen');
    expect(bank2.group, AccountGroup.personal);
    expect(bank2.currencyCode, 'EUR');
    expect(bank2.balance, 980.25);
    expect(bank2.overdraftLimit, 500);
    expect(bank2.iconCodePoint, 0xe0af);
    expect(bank2.colorArgb, 0xFF2F7DD1);
    expect(bank2.createdAt, bank.createdAt);
    final ana2 = b.accounts.singleWhere((a) => a.id == 'acc-ana');
    expect(ana2.group, AccountGroup.individuals);
    expect(ana2.balance, -120);

    final adv2 = b.transactions.singleWhere((t) => t.id == 'tx-advance');
    expect(adv2.nativeAmount, 100);
    expect(adv2.destinationAmount, 108.4);
    expect(adv2.exchangeRate, 1);
    // Decoded rows carry ids; objects are linked when the import is applied.
    expect(adv2.fromAccount?.id ?? adv2.fromAccountId, 'acc-bank');
    expect(adv2.toAccount?.id ?? adv2.toAccountId, 'acc-ana');
    expect(adv2.txType, TxType.advance);
    expect(adv2.category, 'Gifts');
    expect(adv2.date, advance.date);
    expect(adv2.createdAt, advance.createdAt);
    expect(adv2.updatedAt, advance.updatedAt);
    expect(adv2.toSnapshotName, 'Ana');
    expect(adv2.toSnapshotCurrency, 'USD');
    final exp2 = b.transactions.singleWhere((t) => t.id == 'tx-groceries');
    expect(exp2.description, 'Market');
    expect(exp2.toAccount?.id ?? exp2.toAccountId, isNull);
    expect(exp2.attachments, isEmpty);

    final rent2 = b.plannedTransactions.single;
    expect(rent2.id, 'pl-rent');
    expect(rent2.nativeAmount, 650);
    expect(rent2.fromAccount?.id ?? rent2.fromAccountId, 'acc-bank');
    expect(rent2.repeatInterval, RepeatInterval.monthly);
    expect(rent2.repeatDayOfMonth, 1);
    expect(rent2.weekendAdjustment, WeekendAdjustment.previousFriday);
    expect(rent2.repeatEndAfter, 12);
    expect(rent2.repeatConfirmedCount, 2);
    expect(rent2.date, rent.date);
    expect(rent2.txType, TxType.expense);
  });
}
