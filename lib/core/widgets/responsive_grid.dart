import 'package:flutter/material.dart';

import '../theme/breakpoints.dart';

/// Lays children out in 1, 2 or 3 columns depending on screen size.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.compactColumns = 1,
    this.mediumColumns = 2,
    this.expandedColumns = 3,
    this.spacing = 16,
  });

  final List<Widget> children;
  final int compactColumns;
  final int mediumColumns;
  final int expandedColumns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final columns = switch (context.screenSize) {
      ScreenSize.compact => compactColumns,
      ScreenSize.medium => mediumColumns,
      ScreenSize.expanded => expandedColumns,
    };
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}
