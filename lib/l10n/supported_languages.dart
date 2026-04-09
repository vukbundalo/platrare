import 'package:flutter/material.dart';

/// BCP-47 tags for languages users can pick (excluding [kLocaleTagSystem]).
/// Order: widely used global, then European, then regional Slavic + scripts.
const List<String> kSelectableLocaleTags = [
  'en',
  'es',
  'fr',
  'de',
  'pt_BR',
  'it',
  'ru',
  'pl',
  'uk',
  'nl',
  'tr',
  'sv',
  'hi',
  'ar',
  'ja',
  'ko',
  'zh_Hans',
  'hr',
  'bs',
  'sr_Latn',
  'sr_Cyrl',
];

/// Persisted value meaning “follow the device”.
const String kLocaleTagSystem = 'system';

/// Native-script name for settings UI (picker + subtitle). Not localized —
/// users recognize their own language.
String localeEndonym(String tag) => switch (tag) {
      'en' => 'English',
      'es' => 'Español',
      'fr' => 'Français',
      'de' => 'Deutsch',
      'pt_BR' => 'Português (Brasil)',
      'it' => 'Italiano',
      'ru' => 'Русский',
      'pl' => 'Polski',
      'uk' => 'Українська',
      'nl' => 'Nederlands',
      'tr' => 'Türkçe',
      'sv' => 'Svenska',
      'hi' => 'हिन्दी',
      'ar' => 'العربية',
      'ja' => '日本語',
      'ko' => '한국어',
      'zh_Hans' => '简体中文',
      'hr' => 'Hrvatski',
      'bs' => 'Bosanski',
      'sr_Latn' => 'Srpski (latinica)',
      'sr_Cyrl' => 'Српски (ћирилица)',
      _ => tag,
    };

/// Short label on the settings row.
String localeBadge(String tag) => switch (tag) {
      'en' => 'EN',
      'es' => 'ES',
      'fr' => 'FR',
      'de' => 'DE',
      'pt_BR' => 'PT',
      'it' => 'IT',
      'ru' => 'RU',
      'pl' => 'PL',
      'uk' => 'UK',
      'nl' => 'NL',
      'tr' => 'TR',
      'sv' => 'SV',
      'hi' => 'HI',
      'ar' => 'AR',
      'ja' => 'JA',
      'ko' => 'KO',
      'zh_Hans' => 'CN',
      'hr' => 'HR',
      'bs' => 'BS',
      'sr_Latn' => 'SR',
      'sr_Cyrl' => 'SR',
      _ => tag.length > 3 ? tag.substring(0, 3).toUpperCase() : tag.toUpperCase(),
    };

/// Maps a stored tag to a Flutter [Locale] for [MaterialApp.locale].
Locale localeFromStoredTag(String tag) {
  switch (tag) {
    case 'pt_BR':
      return const Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR');
    case 'zh_Hans':
      return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
    case 'sr_Cyrl':
      return const Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Cyrl');
    case 'sr_Latn':
      return const Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn');
    default:
      return Locale(tag);
  }
}

/// Tags passed to [initializeDateFormatting] (best-effort per locale).
String dateFormattingInitTag(String tag) => switch (tag) {
      'pt_BR' => 'pt_BR',
      'zh_Hans' => 'zh_Hans',
      'sr_Latn' => 'sr_Latn',
      'sr_Cyrl' => 'sr',
      _ => tag.split('_').first,
    };
