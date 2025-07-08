import 'package:platrare/models/account.dart';
import 'package:platrare/models/enums.dart';

List<Account> dummyAccounts = [
  // — Personal Accounts —
  Account(
    name: 'Cash',
    type: AccountType.personal,
    balance: 300.0,
    includeInBalance: true,
  ),
  Account(
    name: 'Card',
    type: AccountType.personal,
    balance: 450.0,
    includeInBalance: true,
  ),
  Account(
    name: 'Piggy bank',
    type: AccountType.personal,
    balance: 27.0,
    includeInBalance: false,
  ),

  // — Partner Accounts —
  Account(
    name: 'Nevena Bundalo',
    type: AccountType.partner,
    balance: 454,
    includeInBalance: false,
  ),
  Account(
    name: 'Željko Bundalo',
    type: AccountType.partner,
    balance: -3143,
    includeInBalance: false,
  ),
  Account(
    name: 'Nova Banka',
    type: AccountType.partner,
    balance: -1400,
    includeInBalance: false,
  ),
  Account(
    name: 'Electricity',
    type: AccountType.partner,
    balance: -1400,
    includeInBalance: false,
  ),
  Account(
    name: 'Building',
    type: AccountType.partner,
    balance: -1400,
    includeInBalance: false,
  ),
  Account(
    name: 'RTV',
    type: AccountType.partner,
    balance: -1400,
    includeInBalance: false,
  ),
  Account(
    name: 'Sanitation',
    type: AccountType.partner,
    balance: -1400,
    includeInBalance: false,
  ),

  // — Vendor Accounts —
  Account(
    name: 'Replay',
    type: AccountType.vendor,
    balance: 240,
    includeInBalance: false,
  ),
  Account(
    name: 'Moj Market',
    type: AccountType.vendor,
    balance: 423,
    includeInBalance: false,
  ),

  // — Income Source Accounts —
  Account(
    name: 'East Code d.o.o',
    type: AccountType.incomeSource,
    balance: 54000,
    includeInBalance: false,
  ),
  Account(
    name: 'Apiary Bundalo',
    type: AccountType.incomeSource,
    balance: 4500,
    includeInBalance: false,
  ),

  // — Budget Accounts —
  Account(
    name: 'Food',
    type: AccountType.budget,
    balance: 300.0,
    includeInBalance: false,
  ),
  Account(
    name: 'Coffee',
    type: AccountType.budget,
    balance: 150.0,
    includeInBalance: false,
  ),

  // — Category Accounts —
  Account(
    name: 'Nightout',
    type: AccountType.category,
    balance: 220,
    includeInBalance: false,
  ),
  Account(
    name: 'Car',
    type: AccountType.category,
    balance: 700,
    includeInBalance: false,
  ),
];
