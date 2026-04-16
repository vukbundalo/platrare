import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'user_settings.dart' as settings;

/// Fixed BAM/EUR peg used by the Central Bank of BiH.
const double _bamEurPeg = 1.95583;

const String _cacheKey = 'cached_fx_rates';
const Duration _staleness = Duration(hours: 6);

/// Mobile / simulator networks can be slow; v2 host is sometimes slower than legacy.
const Duration _httpTimeout = Duration(seconds: 20);

/// Singleton service that keeps [settings.exchangeRates] up-to-date with ECB
/// data via the Frankfurter API (v2 on api.frankfurter.dev, with legacy fallback).
class FxService {
  FxService._();
  static final FxService instance = FxService._();

  DateTime? _lastUpdated;

  /// When the rates were last successfully fetched (or loaded from cache).
  DateTime? get lastUpdated => _lastUpdated;

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  /// Call once at app startup.  Loads cached rates synchronously (via the
  /// already-initialised SharedPreferences), then kicks off a background
  /// refresh if the cache is stale.
  Future<void> init() async {
    await _loadFromCache();
    if (_isCacheStale) {
      // Fire-and-forget; errors are swallowed inside refreshRates().
      refreshRates();
    }
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Fetch fresh rates from Frankfurter and update the global map + cache.
  /// Returns silently on failure (keeps existing rates).
  Future<void> refreshRates() async {
    try {
      Map<String, double>? apiRates = await _fetchFrankfurterV2Rates();

      // If v2 fails (timeout, DNS, empty body), still try legacy — the old code
      // never reached here when the first `.timeout` threw.
      if (apiRates == null || apiRates.isEmpty) {
        apiRates = await _fetchFrankfurterLegacyRates();
      }

      if (apiRates == null || apiRates.isEmpty) {
        debugPrint(
          '[FxService] No usable response from v2 or legacy API – keeping cached rates',
        );
        return;
      }

      final now = DateTime.now().toUtc();
      _applyApiRates(apiRates);
      _lastUpdated = now;

      await _saveToCache(apiRates, now);
      debugPrint('[FxService] Rates updated (${apiRates.length} currencies)');
    } catch (e) {
      debugPrint('[FxService] Refresh failed: $e – keeping cached/hardcoded rates');
    }
  }

  /// Frankfurter v2 JSON array at api.frankfurter.dev; returns null on any failure.
  Future<Map<String, double>?> _fetchFrankfurterV2Rates() async {
    try {
      final v2 = Uri.parse('https://api.frankfurter.dev/v2/rates?base=EUR');
      final response = await http.get(v2).timeout(_httpTimeout);
      if (response.statusCode != 200) return null;
      final decoded = jsonDecode(response.body);
      if (decoded is! List<dynamic>) return null;
      final parsed = parseFrankfurterV2(decoded, outDataAsOf: (_) {});
      return parsed.isEmpty ? null : parsed;
    } catch (e) {
      debugPrint('[FxService] v2 rates request failed ($e), trying legacy…');
      return null;
    }
  }

  /// Legacy v1 shape on api.frankfurter.app (still served as of 2026).
  Future<Map<String, double>?> _fetchFrankfurterLegacyRates() async {
    try {
      final legacy = Uri.parse('https://api.frankfurter.app/latest?base=EUR');
      final legacyRes = await http.get(legacy).timeout(_httpTimeout);
      if (legacyRes.statusCode != 200) {
        debugPrint(
          '[FxService] Legacy HTTP ${legacyRes.statusCode} – keeping cached rates',
        );
        return null;
      }
      final body = jsonDecode(legacyRes.body) as Map<String, dynamic>;
      final rates = (body['rates'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble()));
      return rates.isEmpty ? null : rates;
    } catch (e) {
      debugPrint('[FxService] Legacy rates request failed: $e');
      return null;
    }
  }

  /// Frankfurter v2 returns a JSON array of `{date, base, quote, rate}`.
  static Map<String, double> parseFrankfurterV2(
    List<dynamic> rows, {
    void Function(DateTime?)? outDataAsOf,
  }) {
    final out = <String, double>{};
    DateTime? newest;
    for (final row in rows) {
      if (row is! Map<String, dynamic>) continue;
      final quote = row['quote'] as String?;
      final rate = row['rate'];
      if (quote == null || quote == 'EUR' || rate is! num) continue;
      out[quote] = rate.toDouble();
      final ds = row['date'] as String?;
      if (ds != null) {
        final d = DateTime.tryParse(ds);
        if (d != null && (newest == null || d.isAfter(newest))) {
          newest = d;
        }
      }
    }
    outDataAsOf?.call(newest?.toUtc());
    return out;
  }

  // ---------------------------------------------------------------------------
  // Cache
  // ---------------------------------------------------------------------------

  bool get _isCacheStale =>
      _lastUpdated == null ||
      DateTime.now().toUtc().difference(_lastUpdated!) > _staleness;

  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null) return;

      final json = jsonDecode(raw) as Map<String, dynamic>;
      final ts = DateTime.tryParse(json['lastUpdated'] as String? ?? '');
      final rates = (json['rates'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, (v as num).toDouble()));

      if (ts != null && rates != null && rates.isNotEmpty) {
        _applyApiRates(rates);
        _lastUpdated = ts;
        debugPrint('[FxService] Loaded ${rates.length} cached rates from $ts');
      }
    } catch (e) {
      debugPrint('[FxService] Cache load failed: $e');
    }
  }

  Future<void> _saveToCache(Map<String, double> apiRates, DateTime ts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode({
        'lastUpdated': ts.toIso8601String(),
        'rates': apiRates,
      });
      await prefs.setString(_cacheKey, json);
    } catch (e) {
      debugPrint('[FxService] Cache save failed: $e');
    }
  }

  /// Clears the on-disk rate cache and resets the last-updated timestamp.
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    _lastUpdated = null;
  }

  // ---------------------------------------------------------------------------
  // Rate conversion
  // ---------------------------------------------------------------------------

  /// Convert raw API rates (EUR-based) to BAM-based and merge into the global
  /// [settings.exchangeRates].  Currencies present in the API response are
  /// overwritten; currencies absent from the API but already in the map are
  /// left untouched (hardcoded fallback).
  void _applyApiRates(Map<String, double> apiRates) {
    // Fixed pegs – always override.
    settings.exchangeRates['BAM'] = 1.0;
    settings.exchangeRates['EUR'] = _bamEurPeg;

    for (final entry in apiRates.entries) {
      final code = entry.key;
      final eurRate = entry.value; // 1 EUR = eurRate units of X
      if (code == 'EUR') continue;

      // 1 X = 1/eurRate EUR = _bamEurPeg/eurRate BAM
      if (eurRate > 0) {
        settings.exchangeRates[code] = _bamEurPeg / eurRate;
      }
    }
  }
}
