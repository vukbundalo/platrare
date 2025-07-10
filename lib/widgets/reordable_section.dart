import 'package:flutter/material.dart';
import 'package:platrare/widgets/section_header.dart';

class ReorderableSection<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final void Function(int oldIndex, int newIndex) onReorder;

  ReorderableSection({
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext c) {
    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text('No $title yet.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          proxyDecorator: (child, index, animation) => child,
          onReorder: onReorder,
          itemBuilder:
              (_, idx) => ReorderableDragStartListener(
                key: ValueKey(items[idx]),
                index: idx,
                child: itemBuilder(items[idx]),
              ),
        ),
      ],
    );
  }
}
