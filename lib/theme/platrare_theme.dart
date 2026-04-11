import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ledger_colors.dart';

/// Material 3 theme: institutional blue seed, Inter typography, cool surfaces.
ThemeData buildPlatrareTheme(Brightness brightness) {
  const seed = Color(0xFF1A56DB);
  final baseScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: brightness,
  );

  // Light: subtle blue lift. Dark: pure Material 3 surface — no blue tint.
  final cs = brightness == Brightness.light
      ? baseScheme.copyWith(
          surfaceTint: Colors.transparent,
          surface: Color.alphaBlend(
            baseScheme.primary.withValues(alpha: 0.022),
            baseScheme.surface,
          ),
        )
      : baseScheme.copyWith(surfaceTint: Colors.transparent);

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    extensions: [LedgerColors.harmonized(cs)],
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: cs.onSurface,
        letterSpacing: -0.4,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: brightness == Brightness.light
              ? cs.primary.withValues(alpha: 0.14)
              : cs.outlineVariant.withValues(alpha: 0.40),
        ),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cs.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.primary, width: 2.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: TextStyle(color: cs.onSurfaceVariant),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide(color: cs.outlineVariant),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      height: 68,
      backgroundColor: Colors.transparent,
      indicatorColor:
          Color.alphaBlend(cs.primary.withValues(alpha: 0.22), cs.surface),
      surfaceTintColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: 0.1,
          color: selected ? cs.primary : cs.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: 24,
          color: selected ? cs.primary : cs.onSurfaceVariant,
        );
      }),
    ),
    dividerTheme: DividerThemeData(
      color: Color.alphaBlend(
        cs.primary.withValues(alpha: brightness == Brightness.light ? 0.06 : 0.12),
        cs.outlineVariant.withValues(alpha: 0.5),
      ),
      space: 0,
      thickness: 1.0,
    ),
    listTileTheme: const ListTileThemeData(
      minVerticalPadding: 12,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 52),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: cs.primary.withValues(alpha: 0.45)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    dialogTheme: DialogThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: cs.surfaceContainerHigh,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: cs.surfaceContainerHigh,
      elevation: 1,
    ),
  );

  final inter = GoogleFonts.interTextTheme(base.textTheme);
  final textTheme = inter.copyWith(
    titleLarge: inter.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
    ),
    titleMedium: inter.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: -0.15,
    ),
    headlineSmall: inter.headlineSmall?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    bodyLarge: inter.bodyLarge?.copyWith(
      height: 1.45,
    ),
    bodyMedium: inter.bodyMedium?.copyWith(
      height: 1.45,
    ),
    labelLarge: inter.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
  );

  return base.copyWith(
    textTheme: textTheme,
    primaryTextTheme: GoogleFonts.interTextTheme(base.primaryTextTheme),
  );
}
