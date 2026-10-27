import 'package:flutter/material.dart';

/// Grade simples que distribui os itens em linhas de mesma altura.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    required this.columns,
    this.spacing = 20,
    this.runSpacing = 20,
  });

  final List<Widget> children;
  final int columns;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    final cols = columns < 1 ? 1 : columns;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += cols) {
      final end = (i + cols) > children.length ? children.length : i + cols;
      final rowChildren = <Widget>[];
      for (var j = i; j < i + cols; j++) {
        if (j > i) rowChildren.add(SizedBox(width: spacing));
        rowChildren.add(
          Expanded(child: j < end ? children[j] : const SizedBox.shrink()),
        );
      }
      if (rows.isNotEmpty) rows.add(SizedBox(height: runSpacing));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rowChildren,
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}
