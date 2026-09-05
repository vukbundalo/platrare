import 'package:flutter/material.dart';

import '../data/currency_localized_names.dart';
import '../data/user_settings.dart' as settings;
import '../l10n/app_localizations.dart';
import '../utils/fx.dart' as fx;

/// Searchable list of [settings.supportedCurrencies]; pops the chosen code.
///
/// ```dart
/// final code = await showModalBottomSheet<String>(
///   context: context,
///   isScrollControlled: true,
///   builder: (_) => CurrencyPickerSheet(current: settings.baseCurrency),
/// );
/// ```
/// Searchable list of [settings.supportedCurrencies]; pops the chosen code.
class CurrencyPickerSheet extends StatefulWidget {
  final String current;
  const CurrencyPickerSheet({super.key, required this.current});

  @override
  State<CurrencyPickerSheet> createState() => CurrencyPickerSheetState();
}

class CurrencyPickerSheetState extends State<CurrencyPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final filtered = settings.supportedCurrencies
        .where((c) {
          if (_query.isEmpty) return true;
          final q = _query.toLowerCase();
          final name = currencyDisplayName(c, locale).toLowerCase();
          return c.toLowerCase().contains(q) || name.contains(q);
        })
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (ctx, ctrl) => Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.searchCurrencies,
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () => setState(() {
                          _searchController.clear();
                          _query = '';
                        }),
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: ctrl,
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final code = filtered[i];
                final name =
                    currencyDisplayName(code, Localizations.localeOf(context));
                final isSelected = code == widget.current;
                return ListTile(
                  leading: Container(
                    width: 44,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.primaryContainer
                          : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        fx.currencySymbol(code),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color:
                              isSelected ? cs.primary : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  title: Text(code,
                      style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 14)),
                  subtitle: Text(name,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant)),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded,
                          color: cs.primary, size: 18)
                      : null,
                  onTap: () => Navigator.pop(ctx, code),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
