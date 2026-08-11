import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Locale, basicLocaleListResolution;
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../l10n/supported_languages.dart';
import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../utils/fx.dart' as fx;
import '../utils/projections.dart';
import '../utils/tx_display.dart' show txAmountDisplay;
import 'account_lifecycle.dart' show compareAccountsStorageOrder;
import 'app_data.dart' as data;
import 'balance_privacy_prefs.dart';
import 'locale_prefs.dart';
import 'security_prefs.dart';
import 'user_settings.dart' as settings;
import 'widget_bridge.dart';
import 'widget_prefs.dart';

/// Builds the JSON snapshot that the iOS home-screen widgets render from.
///
/// The widget extension is a separate, sandboxed process: it cannot open the
/// app's SQLite database and cannot read the ARB translations. So the app
/// precomputes everything — a 35-day projection series, the derived metrics,
/// and every visible label already localized — and drops one file into the
/// App Group container. The widget only ever renders.
///
/// The 35-day series is what lets the widget's TimelineProvider roll over day
/// by day with the app never running.
///
/// Modelled on [PlannedReminderService]: same `_initialized` flag, same 400 ms
/// trailing debounce, same "swallow every error" posture. Nothing here may
/// ever break a ledger write path.
class WidgetSnapshotService {
  WidgetSnapshotService._();

  static final WidgetSnapshotService instance = WidgetSnapshotService._();

  /// Days of projection shipped in one snapshot. Covers a full month plus a
  /// few days of slack so the widget survives a long stretch without launches.
  static const int kDayCount = 35;

  /// Current schema. Bump only on a breaking change — the widget refuses to
  /// render a major version it does not know.
  static const int kSchemaVersion = 1;

  static const List<String> kWidgetKinds = [
    'PlatrareQuickAdd',
    'PlatrareNumbers',
  ];

  bool _initialized = false;
  Timer? _debounce;
  bool _writing = false;
  bool _pendingWhileWriting = false;

  /// sha256 of the last payload with volatile fields removed. Used to skip
  /// WidgetKit reloads that would change nothing on screen.
  String? _lastContentHash;
  DateTime? _lastReloadAt;

  /// WidgetKit enforces a per-app daily reload budget; exhausting it freezes
  /// every widget for the rest of the day.
  static const Duration _minReloadInterval = Duration(seconds: 60);

  bool get _isSupported => WidgetBridge.isSupported;

  Future<void> init() async {
    if (_initialized || !_isSupported) return;
    _initialized = true;

    // Locale drives every string in the payload and the shortcut item titles.
    appLocaleTag.addListener(_onLocaleChanged);
    balancePrivacyHideByDefault.addListener(requestUpdate);
    appSecurityEnabled.addListener(requestUpdate);
    widgetShowAmounts.addListener(requestUpdate);

    await _write(force: true);
    await _registerShortcutItems();
  }

  void _onLocaleChanged() {
    requestUpdate();
    unawaited(_registerShortcutItems());
  }

  /// Debounced rebuild. Safe to call after every mutation — confirming a
  /// planned row is remove + add + spawn, three calls that collapse into one.
  void requestUpdate() {
    if (!_initialized || !_isSupported) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      unawaited(_write());
    });
  }

  /// Immediate, awaited write. Used on app pause — the last moment before the
  /// widget becomes the only visible surface.
  Future<void> flush() async {
    if (!_initialized || !_isSupported) return;
    _debounce?.cancel();
    await _write(force: true);
  }

  Future<void> _write({bool force = false}) async {
    if (_writing) {
      _pendingWhileWriting = true;
      return;
    }
    _writing = true;
    try {
      final payload = _build();
      final json = jsonEncode(payload);

      final ok = await WidgetBridge.writeSnapshot(json);
      if (!ok) return;

      // Hash without the volatile timestamp so an identical ledger does not
      // burn a reload.
      final stable = Map<String, dynamic>.from(payload)..remove('generatedAt');
      final hash = sha256.convert(utf8.encode(jsonEncode(stable))).toString();
      final now = DateTime.now();
      final throttled = _lastReloadAt != null &&
          now.difference(_lastReloadAt!) < _minReloadInterval;

      if (hash == _lastContentHash && !force) return;
      if (throttled && !force) return;

      _lastContentHash = hash;
      _lastReloadAt = now;
      await WidgetBridge.reloadWidgets(kWidgetKinds);
    } catch (e, st) {
      debugPrint('[WidgetSnapshot] write failed: $e\n$st');
    } finally {
      _writing = false;
      if (_pendingWhileWriting) {
        _pendingWhileWriting = false;
        requestUpdate();
      }
    }
  }

  // ─── Payload ───────────────────────────────────────────────────────────────

  Map<String, dynamic> _build() {
    final l10n = _lookupL10n();
    final localeTag = _resolvedLocale().toLanguageTag();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final base = settings.baseCurrency;
    final digits = fx.currencyMinorUnits(base);
    final symbol = fx.currencySymbol(base);

    final masked = widgetAmountsMasked(
      hideHeroBalances: balancePrivacyHideByDefault.value,
    );

    final series = projectBalancesSeries(today, kDayCount);
    final dayFmt = DateFormat('d MMM', localeTag);
    final isoFmt = DateFormat('yyyy-MM-dd');

    // Aggregates deliberately use the real personalTotal / netWorthInBase,
    // which fold over ALL accounts including archived ones — exactly what the
    // in-app Review hero does. Filtering here would make the widget disagree
    // with the app.
    final days = <Map<String, dynamic>>[];
    for (var i = 0; i < kDayCount; i++) {
      final d = DateTime(today.year, today.month, today.day + i);
      final entry = <String, dynamic>{
        'd': isoFmt.format(d),
        'dLabel': dayFmt.format(d),
        'sp': _round(personalTotal(series[i])),
        'nw': _round(netWorthInBase(series[i])),
      };
      if (i == 0) {
        entry['spText'] = _fmtSigned(entry['sp'] as double, digits, symbol);
        entry['nwText'] = _fmtSigned(entry['nw'] as double, digits, symbol);
      }
      days.add(entry);
    }

    // Last day of the current month, clamped into the window.
    final endOfMonth = DateTime(today.year, today.month + 1, 0);
    var endOfMonthIndex = endOfMonth.difference(today).inDays;
    if (endOfMonthIndex < 0) endOfMonthIndex = 0;
    if (endOfMonthIndex > kDayCount - 1) endOfMonthIndex = kDayCount - 1;

    Map<String, dynamic> lowest(String key) {
      var bestIndex = 0;
      var bestValue = days[0][key] as double;
      for (var i = 1; i <= endOfMonthIndex; i++) {
        final v = days[i][key] as double;
        if (v < bestValue) {
          bestValue = v;
          bestIndex = i;
        }
      }
      return {
        'index': bestIndex,
        'd': days[bestIndex]['d'],
        'dLabel': days[bestIndex]['dLabel'],
        'dayOffset': bestIndex,
        'v': bestValue,
        'vText': _fmtSigned(bestValue, digits, symbol),
      };
    }

    final visible = data.accounts.where((a) => !a.archived).toList()
      ..sort(compareAccountsStorageOrder);
    const maxAccounts = 40;
    final truncated = visible.length > maxAccounts;
    final accounts = <Map<String, dynamic>>[];
    for (final a in visible.take(maxAccounts)) {
      accounts.add({
        'id': a.id,
        'name': a.name,
        'institution': a.institution ?? '',
        'displayName': _displayName(a),
        'group': a.group.name,
        'currency': a.currencyCode,
        'symbol': fx.currencySymbol(a.currencyCode),
        'digits': fx.currencyMinorUnits(a.currencyCode),
        'colorArgb': a.colorArgb,
        'iconCodePoint': a.iconCodePoint,
        'v0': _round(series[0][a.id] ?? a.balance),
        'v0Base': _round(fx.toBase(series[0][a.id] ?? a.balance, a.currencyCode)),
        'series': [
          for (var i = 0; i < kDayCount; i++)
            _round(series[i][a.id] ?? a.balance),
        ],
      });
    }

    return {
      'schemaVersion': kSchemaVersion,
      'generatedAt': now.toUtc().toIso8601String(),
      'generatedDay': isoFmt.format(today),
      'staleAfterDay': isoFmt.format(
        DateTime(today.year, today.month, today.day + kDayCount),
      ),
      'localeTag': localeTag,
      'textDirection': _isRtl(localeTag) ? 'rtl' : 'ltr',
      'baseCurrency': base,
      'format': {
        'symbol': symbol,
        'digits': digits,
        'position': 'suffix',
        'separator': ' ',
      },
      // Parity tripwire: Swift reproduces fx.formatNative arithmetically. If
      // that formatter ever becomes locale-aware, this stops matching and the
      // widget falls back to the pre-formatted *Text fields.
      'formatSample': {
        'v': -1234.5,
        'text': _fmtSigned(-1234.5, digits, symbol),
      },
      'maskAmounts': masked,
      'maskPlaceholder': '••••',
      'hasData': visible.isNotEmpty,
      'strings': {
        'appName': l10n.appTitle,
        'spendableNow': l10n.heroBalance,
        'netWorth': l10n.heroNet,
        'lowestPoint': l10n.widgetLowestPoint,
        'projected': l10n.widgetProjected,
        'horizonToday': l10n.dateToday,
        'horizon7d': l10n.widgetHorizonIn7Days,
        'horizonEndOfMonth': l10n.widgetHorizonEndOfMonth,
        'accountMetric': l10n.widgetMetricAccount,
        'addTracked': l10n.emptyAddTransaction,
        'addPlanned': l10n.planAddPlan,
        'quickAdd': l10n.widgetQuickAdd,
        'emptyTitle': l10n.emptyNoAccountsYet,
        'emptyBody': l10n.widgetOpenToStart,
        'stale': l10n.widgetStale,
        'confirm': l10n.confirm,
        'dueToday': l10n.widgetDueToday,
      },
      'series': {'dayCount': kDayCount, 'days': days},
      'derived': {
        'plus7Index': kDayCount > 7 ? 7 : kDayCount - 1,
        'endOfMonthIndex': endOfMonthIndex,
        'lowestSpendable': lowest('sp'),
        'lowestNetWorth': lowest('nw'),
      },
      'accountsTruncated': truncated,
      'accounts': accounts,
      // Written in v1 but unused by the v1 widgets: seeds the Phase 2
      // "due today + confirm" widget without a schema bump.
      'plannedDueToday': _plannedDueToday(today),
    };
  }

  List<Map<String, dynamic>> _plannedDueToday(DateTime today) {
    final out = <Map<String, dynamic>>[];
    final rows = List<PlannedTransaction>.from(data.plannedTransactions)
      ..sort((a, b) => a.date.compareTo(b.date));
    for (final pt in rows) {
      final due = DateTime(pt.date.year, pt.date.month, pt.date.day);
      if (due.isAfter(today)) continue; // today and overdue only
      final amt = pt.nativeAmount;
      if (amt == null) continue;
      final ccy = pt.currencyCode ?? settings.baseCurrency;
      out.add({
        'id': pt.id,
        'title': _plannedTitle(pt),
        'amount': _round(amt),
        'amountText': pt.txType != null
            ? txAmountDisplay(pt.txType!, amt, ccy)
            : '${fx.formatNativeAmountDigits(amt, ccy)} ${fx.currencySymbol(ccy)}',
        'currency': ccy,
        'dueDay': DateFormat('yyyy-MM-dd').format(due),
        'overdue': due.isBefore(today),
        // Lets a queued confirm detect a row edited after the widget rendered.
        'stamp': (pt.updatedAt ?? pt.createdAt).toUtc().toIso8601String(),
      });
      if (out.length >= 12) break;
    }
    return out;
  }

  String _plannedTitle(PlannedTransaction pt) {
    final d = pt.description?.trim();
    if (d != null && d.isNotEmpty) return d;
    final c = pt.category?.trim();
    if (c != null && c.isNotEmpty) return c;
    return pt.fromAccount?.name ?? pt.toAccount?.name ?? '—';
  }

  Future<void> _registerShortcutItems() async {
    if (!_isSupported) return;
    final l10n = _lookupL10n();
    await WidgetBridge.setShortcutItems([
      {
        'type': 'com.platrare.app.addTracked',
        'title': l10n.emptyAddTransaction,
        'icon': 'plus.circle.fill',
      },
      {
        'type': 'com.platrare.app.addPlanned',
        'title': l10n.planAddPlan,
        'icon': 'calendar.badge.plus',
      },
    ]);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static String _displayName(Account a) {
    final inst = a.institution?.trim() ?? '';
    return inst.isEmpty ? a.name : '${a.name} ($inst)';
  }

  /// Keeps the JSON compact and stable across rebuilds (avoids 1e-13 churn
  /// defeating the content hash).
  static double _round(double v) => double.parse(v.toStringAsFixed(4));

  /// Signed counterpart of [fx.formatNative], which drops the sign via .abs().
  /// Balances must keep it. Swift mirrors this exactly.
  static String _fmtSigned(double v, int digits, String symbol) =>
      '${v.toStringAsFixed(digits)} $symbol';

  static bool _isRtl(String tag) {
    final lang = tag.split(RegExp('[-_]')).first.toLowerCase();
    return const {'ar', 'he', 'fa', 'ur'}.contains(lang);
  }

  /// Effective locale, mirroring MaterialApp resolution the same way
  /// [PlannedReminderService] does for notification text.
  Locale _resolvedLocale() {
    final tag = appLocaleTag.value;
    return tag == kLocaleTagSystem
        ? basicLocaleListResolution(
            PlatformDispatcher.instance.locales,
            AppLocalizations.supportedLocales,
          )
        : localeFromStoredTag(tag);
  }

  AppLocalizations _lookupL10n() => lookupAppLocalizations(_resolvedLocale());

  @visibleForTesting
  Map<String, dynamic> buildForTest() => _build();
}
