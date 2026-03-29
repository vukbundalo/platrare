import 'package:flutter/material.dart';
import '../data/app_data.dart' as data;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _addCategory(List<String> targetList) async {
    final controller = TextEditingController();
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('New Category'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Category name'),
            onSubmitted: (v) =>
                Navigator.pop(ctx, v.trim().isEmpty ? null : v.trim()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final v = controller.text.trim();
                Navigator.pop(ctx, v.isEmpty ? null : v);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
      if (result != null && !targetList.contains(result)) {
        setState(() => targetList.add(result));
      }
    } finally {
      controller.dispose();
    }
  }

  void _deleteCategory(String category, List<String> targetList) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete category?'),
        content: Text('"$category" will be removed from the list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => targetList.remove(category));
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: cs.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _SectionLabel('Categories'),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SubSection(
                    label: 'Income',
                    color: const Color(0xFF16A34A),
                    categories: data.incomeCategories,
                    onAdd: () => _addCategory(data.incomeCategories),
                    onDelete: (c) =>
                        _deleteCategory(c, data.incomeCategories),
                  ),
                  const SizedBox(height: 16),
                  Divider(
                      height: 1,
                      color: cs.outlineVariant.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  _SubSection(
                    label: 'Expense',
                    color: const Color(0xFFDC2626),
                    categories: data.expenseCategories,
                    onAdd: () => _addCategory(data.expenseCategories),
                    onDelete: (c) =>
                        _deleteCategory(c, data.expenseCategories),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _SubSection extends StatelessWidget {
  final String label;
  final Color color;
  final List<String> categories;
  final VoidCallback onAdd;
  final void Function(String) onDelete;

  const _SubSection({
    required this.label,
    required this.color,
    required this.categories,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: color,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            ...categories.map(
              (cat) => Chip(
                label: Text(cat, style: const TextStyle(fontSize: 12)),
                onDeleted: () => onDelete(cat),
                deleteIcon: const Icon(Icons.close_rounded, size: 13),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            ActionChip(
              avatar: Icon(Icons.add_rounded, size: 14, color: color),
              label: Text(
                'Add',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              onPressed: onAdd,
              side: BorderSide(color: color.withValues(alpha: 0.35)),
              backgroundColor: color.withValues(alpha: 0.08),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ],
    );
  }
}
