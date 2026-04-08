import 'package:flutter/material.dart';

import '../models/account.dart';

/// User-visible account title, including optional identifier ([Account.institution]).
String accountDisplayName(Account a) {
  final inst = a.institution?.trim();
  if (inst == null || inst.isEmpty) return a.name;
  return '${a.name} ($inst)';
}

Color accountAvatarOnBackground(Color background) =>
    ThemeData.estimateBrightnessForColor(background) == Brightness.dark
        ? Colors.white
        : Colors.black87;

/// Background and foreground for account list avatars.
({Color background, Color foreground}) accountAvatarColors(
  Account account,
  ColorScheme cs,
) {
  final custom = account.colorArgb;
  if (custom != null) {
    final bg = Color(custom);
    return (background: bg, foreground: accountAvatarOnBackground(bg));
  }
  final isPersonal = account.group == AccountGroup.personal;
  final isEntities = account.group == AccountGroup.entities;
  final bg = isPersonal
      ? cs.primaryContainer
      : isEntities
          ? cs.secondaryContainer
          : cs.tertiaryContainer;
  final fg = isPersonal
      ? cs.onPrimaryContainer
      : isEntities
          ? cs.onSecondaryContainer
          : cs.onTertiaryContainer;
  return (background: bg, foreground: fg);
}

IconData? accountIconOrNull(Account account) {
  if (account.iconCodePoint == 0) return null;
  return IconData(account.iconCodePoint, fontFamily: 'MaterialIcons');
}

String accountAvatarLetter(Account account) {
  final n = account.name.trim();
  if (n.isEmpty) return '?';
  return n[0].toUpperCase();
}
