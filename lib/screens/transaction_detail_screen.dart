import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../models/planned_transaction.dart';
import '../utils/fx.dart' as fx;
import '../utils/tx_display.dart';

// ─── Transaction Detail ───────────────────────────────────────────────────────

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  TxType get _type =>
      transaction.txType ??
      classifyTransaction(
          from: transaction.fromAccount, to: transaction.toAccount);

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete transaction?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              onDelete();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final type = _type;
    final t = transaction;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Transaction'),
        centerTitle: false,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: cs.error),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
        children: [
          _Banner(type: type, amount: t.nativeAmount, currencyCode: t.currencyCode),
          const SizedBox(height: 20),
          _DetailsCard(children: [
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: DateFormat('EEEE, d MMMM yyyy').format(t.date),
            ),
            if (t.fromAccount != null)
              _DetailRow(
                icon: Icons.outbox_outlined,
                label: 'From',
                value: t.fromAccount!.name,
              ),
            if (t.toAccount != null)
              _DetailRow(
                icon: Icons.inbox_outlined,
                label: 'To',
                value: t.toAccount!.name,
              ),
            if (t.category != null)
              _DetailRow(
                icon: Icons.label_outline_rounded,
                label: 'Category',
                value: t.category!,
              ),
            if (t.description != null)
              _DetailRow(
                icon: Icons.notes_rounded,
                label: 'Note',
                value: t.description!,
              ),
          ]),
          if (t.destinationAmount != null) ...[
            const SizedBox(height: 12),
            _DetailsCard(children: [
              _DetailRow(
                icon: Icons.currency_exchange_rounded,
                label: 'Destination amount',
                value:
                    '${t.destinationAmount!.toStringAsFixed(2)} ${fx.currencySymbol(t.toAccount?.currencyCode ?? 'BAM')}',
              ),
              if (t.exchangeRate != null && t.exchangeRate != 1.0)
                _DetailRow(
                  icon: Icons.swap_vert_rounded,
                  label: 'Exchange rate',
                  value:
                      '1 ${fx.currencySymbol(t.currencyCode ?? 'BAM')} = ${t.exchangeRate!.toStringAsFixed(4)} ${fx.currencySymbol(t.toAccount?.currencyCode ?? 'BAM')}',
                ),
            ]),
          ],
        ],
      ),
    );
  }
}

// ─── Planned Transaction Detail ───────────────────────────────────────────────

class PlannedTransactionDetailScreen extends StatelessWidget {
  final PlannedTransaction pt;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onConfirm;

  const PlannedTransactionDetailScreen({
    super.key,
    required this.pt,
    required this.onEdit,
    required this.onDelete,
    required this.onConfirm,
  });

  TxType get _type =>
      pt.txType ??
      classifyTransaction(from: pt.fromAccount, to: pt.toAccount);

  bool get _canConfirm =>
      !DateUtils.dateOnly(pt.date).isAfter(DateUtils.dateOnly(DateTime.now()));

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete planned transaction?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              onDelete();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final type = _type;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Planned'),
        centerTitle: false,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: cs.error),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context),
          ),
          const SizedBox(width: 4),
        ],
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
                  label: const Text('Confirm transaction'),
                ),
              ),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
        children: [
          _Banner(type: type, amount: pt.nativeAmount, currencyCode: pt.currencyCode),
          const SizedBox(height: 20),
          _DetailsCard(children: [
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: DateFormat('EEEE, d MMMM yyyy').format(pt.date),
            ),
            if (pt.fromAccount != null)
              _DetailRow(
                icon: Icons.outbox_outlined,
                label: 'From',
                value: pt.fromAccount!.name,
              ),
            if (pt.toAccount != null)
              _DetailRow(
                icon: Icons.inbox_outlined,
                label: 'To',
                value: pt.toAccount!.name,
              ),
            if (pt.category != null)
              _DetailRow(
                icon: Icons.label_outline_rounded,
                label: 'Category',
                value: pt.category!,
              ),
            if (pt.description != null)
              _DetailRow(
                icon: Icons.notes_rounded,
                label: 'Note',
                value: pt.description!,
              ),
            if (pt.repeatInterval != RepeatInterval.none)
              _DetailRow(
                icon: Icons.repeat_rounded,
                label: 'Repeats',
                value: repeatLabel(pt.repeatInterval),
              ),
          ]),
          if (pt.destinationAmount != null) ...[
            const SizedBox(height: 12),
            _DetailsCard(children: [
              _DetailRow(
                icon: Icons.currency_exchange_rounded,
                label: 'Destination amount',
                value:
                    '${pt.destinationAmount!.toStringAsFixed(2)} ${fx.currencySymbol(pt.toAccount?.currencyCode ?? 'BAM')}',
              ),
            ]),
          ],
        ],
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _Banner extends StatelessWidget {
  final TxType type;
  final double? amount;
  final String? currencyCode;

  const _Banner({required this.type, this.amount, this.currencyCode});

  @override
  Widget build(BuildContext context) {
    final color = txColor(type);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(txIcon(type), size: 28, color: color),
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              txLabel(type),
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.8),
            ),
          ),
          if (amount != null) ...[
            const SizedBox(height: 10),
            Text(
              txAmountDisplay(type, amount!, currencyCode ?? 'BAM'),
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: color),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final List<Widget> children;
  const _DetailsCard({required this.children});

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

  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: cs.onSurfaceVariant),
          const SizedBox(width: 16),
          Text(label,
              style:
                  TextStyle(fontSize: 14, color: cs.onSurfaceVariant)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
