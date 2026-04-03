import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/account.dart';
import '../models/planned_transaction.dart';

/// [DateFormat] using the widget tree locale (respects app + system language).
String formatAppDate(BuildContext context, String pattern, DateTime date) {
  final tag = Localizations.localeOf(context).toLanguageTag();
  return DateFormat(pattern, tag).format(date);
}

/// Section headers on Review / Plan / pickers (Personal / Individuals / Entities).
String l10nAccountSectionTitle(BuildContext context, AccountGroup group) {
  final l = AppLocalizations.of(context);
  return switch (group) {
    AccountGroup.personal => l.accountGroupPersonal,
    AccountGroup.individuals => l.accountSectionIndividuals,
    AccountGroup.entities => l.accountSectionEntities,
  };
}

/// Subtitle on account cards (Personal / Individual / Entity).
String l10nAccountCardGroupLabel(BuildContext context, AccountGroup group) {
  final l = AppLocalizations.of(context);
  return switch (group) {
    AccountGroup.personal => l.accountGroupPersonal,
    AccountGroup.individuals => l.accountGroupIndividual,
    AccountGroup.entities => l.accountGroupEntity,
  };
}

/// Localized transaction type label (uppercase).
String l10nTxLabel(BuildContext context, TxType t) {
  final l = AppLocalizations.of(context);
  return switch (t) {
    TxType.income => l.txLabelIncome,
    TxType.expense => l.txLabelExpense,
    TxType.invoice => l.txLabelInvoice,
    TxType.bill => l.txLabelBill,
    TxType.advance => l.txLabelAdvance,
    TxType.settlement => l.txLabelSettlement,
    TxType.loan => l.txLabelLoan,
    TxType.collection => l.txLabelCollection,
    TxType.offset => l.txLabelOffset,
    TxType.transfer => l.txLabelTransfer,
  };
}

String l10nRepeatLabel(BuildContext context, RepeatInterval r) {
  final l = AppLocalizations.of(context);
  return switch (r) {
    RepeatInterval.none => l.repeatNone,
    RepeatInterval.daily => l.repeatDaily,
    RepeatInterval.weekly => l.repeatWeekly,
    RepeatInterval.monthly => l.repeatMonthly,
    RepeatInterval.yearly => l.repeatYearly,
  };
}

/// Localized interval-unit word (e.g. "day" / "weeks") for the custom repeat picker.
String l10nRepeatEveryUnit(BuildContext context, RepeatInterval r, int count) {
  final l = AppLocalizations.of(context);
  return switch (r) {
    RepeatInterval.none => '',
    RepeatInterval.daily => l.repeatEveryDays(count),
    RepeatInterval.weekly => l.repeatEveryWeeks(count),
    RepeatInterval.monthly => l.repeatEveryMonths(count),
    RepeatInterval.yearly => l.repeatEveryYears(count),
  };
}

/// Human-readable repeat summary (e.g. "Every 2 weeks, until Jun 15").
String l10nRepeatSummary(BuildContext context, PlannedTransaction pt) {
  if (pt.repeatInterval == RepeatInterval.none) {
    return l10nRepeatLabel(context, RepeatInterval.none);
  }
  final l = AppLocalizations.of(context);
  final unit = l10nRepeatEveryUnit(context, pt.repeatInterval, pt.repeatEvery);
  final buf = StringBuffer();
  if (pt.repeatEvery == 1) {
    buf.write(l10nRepeatLabel(context, pt.repeatInterval));
  } else {
    buf.write(l.repeatSummaryEvery(pt.repeatEvery, unit));
  }
  if (pt.repeatEndDate != null) {
    final dateStr = formatAppDate(context, 'MMMd', pt.repeatEndDate!);
    buf.write(', ${l.repeatSummaryUntil(dateStr)}');
  } else if (pt.repeatEndAfter != null) {
    buf.write(', ${l.repeatSummaryTimes(pt.repeatEndAfter!)}');
  }
  return buf.toString();
}

String l10nWeekendLabel(BuildContext context, WeekendAdjustment w) {
  final l = AppLocalizations.of(context);
  return switch (w) {
    WeekendAdjustment.ignore => l.weekendNoChange,
    WeekendAdjustment.previousFriday => l.weekendFriday,
    WeekendAdjustment.nextMonday => l.weekendMonday,
  };
}

const _defaultCategoryKeys = <String, String>{
  'Salary': 'catSalary',
  'Freelance': 'catFreelance',
  'Consulting': 'catConsulting',
  'Gift': 'catGift',
  'Rental': 'catRental',
  'Dividends': 'catDividends',
  'Refund': 'catRefund',
  'Bonus': 'catBonus',
  'Interest': 'catInterest',
  'Side hustle': 'catSideHustle',
  'Sale of goods': 'catSaleOfGoods',
  'Other': 'catOther',
  'Groceries': 'catGroceries',
  'Dining': 'catDining',
  'Transport': 'catTransport',
  'Utilities': 'catUtilities',
  'Housing': 'catHousing',
  'Healthcare': 'catHealthcare',
  'Entertainment': 'catEntertainment',
  'Shopping': 'catShopping',
  'Travel': 'catTravel',
  'Education': 'catEducation',
  'Subscriptions': 'catSubscriptions',
  'Insurance': 'catInsurance',
  'Fuel': 'catFuel',
  'Gym': 'catGym',
  'Pets': 'catPets',
  'Kids': 'catKids',
  'Charity': 'catCharity',
  'Coffee': 'catCoffee',
  'Gifts': 'catGifts',
};

/// Resolves `__sentinel__` keys stored in transaction category / description
/// fields to their localized display strings.
String l10nSentinel(String? value, AppLocalizations l10n) {
  if (value == null) return '';
  return switch (value) {
    '__balance_adjustment__' => l10n.categoryBalanceAdjustment,
    '__balance_correction__' => l10n.descriptionBalanceCorrection,
    _ => value,
  };
}

/// Translates a default category key to the current locale.
/// User-added categories (not in the default set) are returned as-is.
String l10nCategoryName(BuildContext context, String key) {
  final l = AppLocalizations.of(context);
  if (key == '__balance_adjustment__') return l.categoryBalanceAdjustment;
  final arbKey = _defaultCategoryKeys[key];
  if (arbKey == null) return key;
  return switch (arbKey) {
    'catSalary' => l.catSalary,
    'catFreelance' => l.catFreelance,
    'catConsulting' => l.catConsulting,
    'catGift' => l.catGift,
    'catRental' => l.catRental,
    'catDividends' => l.catDividends,
    'catRefund' => l.catRefund,
    'catBonus' => l.catBonus,
    'catInterest' => l.catInterest,
    'catSideHustle' => l.catSideHustle,
    'catSaleOfGoods' => l.catSaleOfGoods,
    'catOther' => l.catOther,
    'catGroceries' => l.catGroceries,
    'catDining' => l.catDining,
    'catTransport' => l.catTransport,
    'catUtilities' => l.catUtilities,
    'catHousing' => l.catHousing,
    'catHealthcare' => l.catHealthcare,
    'catEntertainment' => l.catEntertainment,
    'catShopping' => l.catShopping,
    'catTravel' => l.catTravel,
    'catEducation' => l.catEducation,
    'catSubscriptions' => l.catSubscriptions,
    'catInsurance' => l.catInsurance,
    'catFuel' => l.catFuel,
    'catGym' => l.catGym,
    'catPets' => l.catPets,
    'catKids' => l.catKids,
    'catCharity' => l.catCharity,
    'catCoffee' => l.catCoffee,
    'catGifts' => l.catGifts,
    _ => key,
  };
}
