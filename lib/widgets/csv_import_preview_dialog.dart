import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/csv/csv_import.dart';
import '../data/csv/csv_value_parse.dart';
import '../l10n/app_localizations.dart';

/// Localized label for a rejected row.
String csvRowProblemLabel(CsvRowProblem problem, AppLocalizations l10n) =>
    switch (problem) {
      CsvRowProblem.missingDate || CsvRowProblem.badDate => l10n.csvRowProblemDate,
      CsvRowProblem.missingAmount ||
      CsvRowProblem.badAmount ||
      CsvRowProblem.zeroAmount =>
        l10n.csvRowProblemAmount,
      CsvRowProblem.noAccount || CsvRowProblem.sameAccount =>
        l10n.csvRowProblemAccount,
      CsvRowProblem.unknownType => l10n.csvRowProblemType,
    };

/// Shows exactly what an import will do before anything is written, and lets
/// the user change the two decisions that alter the outcome: how ambiguous
/// dates are read, and whether rows that already exist are skipped.
///
/// Both re-run [CsvImport.prepare], because the simulated balances depend on
/// which rows are actually written.
class CsvImportPreviewDialog extends StatefulWidget {
  const CsvImportPreviewDialog({
    super.key,
    required this.bytes,
    required this.initialPlan,
    required this.l10n,
  });

  final Uint8List bytes;
  final CsvImportPlan initialPlan;
  final AppLocalizations l10n;

  @override
  State<CsvImportPreviewDialog> createState() => _CsvImportPreviewDialogState();
}

class _CsvImportPreviewDialogState extends State<CsvImportPreviewDialog> {
  static const int _maxListedIssues = 5;
  static const int _maxListedNames = 6;

  late CsvImportPlan _plan;
  late CsvDateStyle _dateStyle;
  late bool _skipDuplicates;

  AppLocalizations get l10n => widget.l10n;

  @override
  void initState() {
    super.initState();
    _plan = widget.initialPlan;
    _dateStyle = _plan.dateStyle;
    _skipDuplicates = _plan.skipDuplicates;
  }

  void _reprepare() {
    setState(() {
      _plan = CsvImport.prepare(
        widget.bytes,
        dateStyle: _dateStyle,
        skipDuplicates: _skipDuplicates,
      );
    });
  }

  String _joinNames(Iterable<String> names) {
    final list = names.toList();
    if (list.length <= _maxListedNames) return list.join(', ');
    final shown = list.take(_maxListedNames).join(', ');
    return '$shown, +${list.length - _maxListedNames}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: cs.onSurfaceVariant,
    );

    final canImport = _plan.importableRows > 0;

    return AlertDialog(
      title: Text(l10n.csvImportPreviewTitle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.csvImportPreviewCounts(
                _plan.importableRows,
                _plan.totalDataRows,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_plan.newAccounts.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                l10n.csvImportPreviewNewAccounts(
                  _joinNames(_plan.newAccounts.map((a) => a.name)),
                ),
                style: muted,
              ),
            ],
            if (_plan.newCategories.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                l10n.csvImportPreviewNewCategories(
                  _joinNames(_plan.newCategories.map((c) => c.name)),
                ),
                style: muted,
              ),
            ],
            if (_plan.dateStyleAmbiguous) ...[
              const SizedBox(height: 16),
              Text(l10n.csvImportPreviewDateStyleTitle, style: muted),
              const SizedBox(height: 8),
              SegmentedButton<CsvDateStyle>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: CsvDateStyle.dayFirst,
                    label: Text(l10n.csvImportPreviewDateStyleDayFirst),
                  ),
                  ButtonSegment(
                    value: CsvDateStyle.monthFirst,
                    label: Text(l10n.csvImportPreviewDateStyleMonthFirst),
                  ),
                ],
                selected: {
                  _dateStyle == CsvDateStyle.monthFirst
                      ? CsvDateStyle.monthFirst
                      : CsvDateStyle.dayFirst,
                },
                onSelectionChanged: (s) {
                  _dateStyle = s.first;
                  _reprepare();
                },
              ),
            ],
            if (_plan.duplicateRows > 0) ...[
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _skipDuplicates,
                onChanged: (v) {
                  _skipDuplicates = v ?? true;
                  _reprepare();
                },
                title: Text(
                  l10n.csvImportPreviewSkipDuplicates,
                  style: theme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  l10n.csvImportPreviewDuplicates(_plan.duplicateRows),
                  style: muted,
                ),
              ),
            ],
            if (_plan.issues.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.csvImportPreviewIssuesTitle(_plan.issues.length),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              for (final issue in _plan.issues.take(_maxListedIssues))
                Text(
                  l10n.csvImportPreviewIssueLine(
                    issue.line,
                    csvRowProblemLabel(issue.problem, l10n),
                  ),
                  style: muted,
                ),
              if (_plan.issues.length > _maxListedIssues)
                Text(
                  l10n.csvImportPreviewIssueMore(
                    _plan.issues.length - _maxListedIssues,
                  ),
                  style: muted,
                ),
            ],
            if (!canImport) ...[
              const SizedBox(height: 16),
              Text(
                l10n.csvImportPreviewNothing,
                style: theme.textTheme.bodyMedium?.copyWith(color: cs.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: canImport ? () => Navigator.pop(context, _plan) : null,
          child: Text(l10n.csvImportPreviewConfirm),
        ),
      ],
    );
  }
}
