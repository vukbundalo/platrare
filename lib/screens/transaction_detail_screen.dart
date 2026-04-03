import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import '../l10n/app_localizations.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../models/planned_transaction.dart';
import '../utils/app_format.dart';
import '../utils/fx.dart' as fx;
import '../utils/tx_display.dart';

// ─── Transaction Detail ───────────────────────────────────────────────────────

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  TxType get _type =>
      transaction.txType ??
      classifyTransaction(
          from: transaction.fromAccount, to: transaction.toAccount);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final type = _type;
    final t = transaction;
    final color = txColor(type);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(l10n.detailTransactionTitle),
        centerTitle: false,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
        children: [
          _Header(type: type, amount: t.nativeAmount, currencyCode: t.currencyCode),
          const SizedBox(height: 16),
          _DetailCard(children: [
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: l10n.detailDate,
              value: formatAppDate(context, 'EEEE, d MMMM yyyy', t.date),
              color: color,
            ),
            if (t.fromAccount != null)
              _DetailRow(
                icon: Icons.outbox_outlined,
                label: l10n.detailFrom,
                value: t.fromAccount!.name,
                subtitle: t.fromAccount!.currencyCode,
                color: color,
              ),
            if (t.toAccount != null)
              _DetailRow(
                icon: Icons.inbox_outlined,
                label: l10n.detailTo,
                value: t.toAccount!.name,
                subtitle: t.toAccount!.currencyCode,
                color: color,
              ),
            if (t.category != null)
              _DetailRow(
                icon: Icons.label_outline_rounded,
                label: l10n.detailCategory,
                value: l10nCategoryName(context, t.category!),
                color: color,
              ),
            if (t.description != null)
              _DetailRow(
                icon: Icons.notes_rounded,
                label: l10n.detailNote,
                value: t.description!,
                color: color,
              ),
            if (t.destinationAmount != null)
              _DetailRow(
                icon: Icons.currency_exchange_rounded,
                label: l10n.detailDestinationAmount,
                value:
                    '${t.destinationAmount!.toStringAsFixed(2)} ${fx.currencySymbol(t.toAccount?.currencyCode ?? 'BAM')}',
                color: color,
              ),
            if (t.exchangeRate != null && t.exchangeRate != 1.0)
              _DetailRow(
                icon: Icons.swap_vert_rounded,
                label: l10n.detailExchangeRate,
                value:
                    '1 ${fx.currencySymbol(t.currencyCode ?? 'BAM')} = ${t.exchangeRate!.toStringAsFixed(4)} ${fx.currencySymbol(t.toAccount?.currencyCode ?? 'BAM')}',
                color: color,
              ),
          ]),
          if (t.attachments.isNotEmpty) ...[
            const SizedBox(height: 12),
            _AttachmentsCard(attachments: t.attachments),
          ],
        ],
      ),
    );
  }
}

// ─── Planned Transaction Detail ───────────────────────────────────────────────

class PlannedTransactionDetailScreen extends StatelessWidget {
  final PlannedTransaction pt;
  final VoidCallback onConfirm;

  const PlannedTransactionDetailScreen({
    super.key,
    required this.pt,
    required this.onConfirm,
  });

  TxType get _type =>
      pt.txType ??
      classifyTransaction(from: pt.fromAccount, to: pt.toAccount);

  bool get _canConfirm => true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final type = _type;
    final color = txColor(type);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(l10n.detailPlannedTitle),
        centerTitle: false,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBar: _canConfirm
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: Text(l10n.detailConfirmTransaction),
                ),
              ),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
        children: [
          _Header(type: type, amount: pt.nativeAmount, currencyCode: pt.currencyCode),
          const SizedBox(height: 16),
          _DetailCard(children: [
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: l10n.detailDate,
              value: formatAppDate(context, 'EEEE, d MMMM yyyy', pt.date),
              color: color,
            ),
            if (pt.fromAccount != null)
              _DetailRow(
                icon: Icons.outbox_outlined,
                label: l10n.detailFrom,
                value: pt.fromAccount!.name,
                subtitle: pt.fromAccount!.currencyCode,
                color: color,
              ),
            if (pt.toAccount != null)
              _DetailRow(
                icon: Icons.inbox_outlined,
                label: l10n.detailTo,
                value: pt.toAccount!.name,
                subtitle: pt.toAccount!.currencyCode,
                color: color,
              ),
            if (pt.category != null)
              _DetailRow(
                icon: Icons.label_outline_rounded,
                label: l10n.detailCategory,
                value: l10nCategoryName(context, pt.category!),
                color: color,
              ),
            if (pt.description != null)
              _DetailRow(
                icon: Icons.notes_rounded,
                label: l10n.detailNote,
                value: pt.description!,
                color: color,
              ),
            if (pt.repeatInterval != RepeatInterval.none)
              _DetailRow(
                icon: Icons.repeat_rounded,
                label: l10n.detailRepeats,
                value: l10nRepeatLabel(context, pt.repeatInterval),
                color: color,
              ),
            if (pt.repeatInterval == RepeatInterval.monthly ||
                pt.repeatInterval == RepeatInterval.yearly) ...[
              if (pt.repeatDayOfMonth != null)
                _DetailRow(
                  icon: Icons.event_repeat_rounded,
                  label: l10n.detailDayOfMonth,
                  value: '${pt.repeatDayOfMonth}',
                  color: color,
                ),
              _DetailRow(
                icon: Icons.event_busy_outlined,
                label: l10n.detailWeekends,
                value: l10nWeekendLabel(context, pt.weekendAdjustment),
                color: color,
              ),
            ],
            if (pt.destinationAmount != null)
              _DetailRow(
                icon: Icons.currency_exchange_rounded,
                label: l10n.detailDestinationAmount,
                value:
                    '${pt.destinationAmount!.toStringAsFixed(2)} ${fx.currencySymbol(pt.toAccount?.currencyCode ?? 'BAM')}',
                color: color,
              ),
          ]),
        ],
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final TxType type;
  final double? amount;
  final String? currencyCode;

  const _Header({required this.type, this.amount, this.currencyCode});

  @override
  Widget build(BuildContext context) {
    final color = txColor(type);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(txIcon(type), size: 26, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10nTxLabel(context, type),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                      letterSpacing: 0.8),
                ),
              ),
              if (amount != null) ...[
                const SizedBox(height: 6),
                Text(
                  txAmountDisplay(type, amount!, currencyCode ?? 'BAM'),
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: -0.5),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;
  const _DetailCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: children.asMap().entries.map((e) {
          final isLast = e.key == children.length - 1;
          return Column(
            children: [
              e.value,
              if (!isLast)
                Divider(
                    height: 0.5,
                    indent: 52,
                    color: cs.outlineVariant.withValues(alpha: 0.4)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color color;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurfaceVariant,
                      letterSpacing: 0.2),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    subtitle!,
                    style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Attachments card ─────────────────────────────────────────────────────────

class _AttachmentsCard extends StatelessWidget {
  final List<String> attachments;
  const _AttachmentsCard({required this.attachments});

  static const _imageExts = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif'};

  bool _isImage(String path) =>
      _imageExts.contains(path.split('.').last.toLowerCase());

  String _filename(String path) => path.split('/').last;

  IconData _fileIcon(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (ext == 'pdf') return Icons.picture_as_pdf_rounded;
    if (ext == 'doc' || ext == 'docx') return Icons.description_rounded;
    if (ext == 'xls' || ext == 'xlsx') return Icons.table_chart_rounded;
    return Icons.insert_drive_file_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.attach_file_rounded,
                      size: 16, color: cs.primary),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.detailAttachments,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: cs.onSurfaceVariant,
                            letterSpacing: 0.2)),
                    const SizedBox(height: 2),
                    Text(l10n.detailFileCount(attachments.length),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 0.5, color: cs.outlineVariant.withValues(alpha: 0.4)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: attachments.map((path) {
                final isImg = _isImage(path);
                return GestureDetector(
                  onTap: () => OpenFilex.open(path),
                  child: isImg
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(path),
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, trace) => _FilePlaceholder(
                              icon: Icons.broken_image_rounded,
                              name: _filename(path),
                              cs: cs,
                            ),
                          ),
                        )
                      : _FilePlaceholder(
                          icon: _fileIcon(path),
                          name: _filename(path),
                          cs: cs,
                        ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilePlaceholder extends StatelessWidget {
  final IconData icon;
  final String name;
  final ColorScheme cs;

  const _FilePlaceholder({
    required this.icon,
    required this.name,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              name,
              style: TextStyle(fontSize: 12, color: cs.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
