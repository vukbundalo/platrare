import 'package:platrare/models/account.dart';

List<Account> dummyAccounts = [
  // — Personal Accounts —
  Account(
    name: 'Cash',
    type: AccountType.personal,
    balance: 0,
    includeInBalance: true,
  ),
  Account(
    name: 'Card',
    type: AccountType.personal,
    balance: 0,
    includeInBalance: true,
  ),
  Account(
    name: 'Piggy bank',
    type: AccountType.personal,
    balance: 0,
    includeInBalance: false,
  ),
    Account(
    name: 'Savings account',
    type: AccountType.personal,
    balance: 0,
    includeInBalance: false,
  ),

  // — Partner Accounts —
  Account(
    name: 'Nevena Bundalo',
    type: AccountType.partner,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Željko Bundalo',
    type: AccountType.partner,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Nova Banka',
    type: AccountType.partner,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Electricity',
    type: AccountType.partner,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Building',
    type: AccountType.partner,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'RTV',
    type: AccountType.partner,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Sanitation',
    type: AccountType.partner,
    balance: 0,
    includeInBalance: false,
  ),

  // — Vendor Accounts —
  Account(
    name: 'Replay',
    type: AccountType.vendor,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Moj Market',
    type: AccountType.vendor,
    balance: 0,
    includeInBalance: false,
  ),

  // — Income Source Accounts —
  Account(
    name: 'East Code d.o.o',
    type: AccountType.incomeSource,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Apiary Bundalo',
    type: AccountType.incomeSource,
    balance: 0,
    includeInBalance: false,
  ),



  // — Category Accounts (default) —
  Account(
    name: 'Groceries',
    type: AccountType.category,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Dining & Drinks',
    type: AccountType.category,
    balance: 0,
    includeInBalance: false,
  ),
      Account(
    name: 'Clothes & Accessories',
    type: AccountType.category,
    balance: 0,
    includeInBalance: false,
  ),
    Account(
    name: 'Utilities',
    type: AccountType.category,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Housing',
    type: AccountType.category,
    balance: 0,
    includeInBalance: false,
  ),
    Account(
    name: 'Car',
    type: AccountType.category,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Healthcare',
    type: AccountType.category,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Travel',
    type: AccountType.category,
    balance: 0,
    includeInBalance: false,
  ),
  Account(
    name: 'Gifts & Donations',
    type: AccountType.category,
    balance: 0,
    includeInBalance: false,
  ),
];
