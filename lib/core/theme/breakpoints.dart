import 'package:flutter/widgets.dart';

enum ScreenSize { compact, medium, expanded }

/// Breakpoints and layout limits from NT-DOC-08 Section 6.
abstract final class Breakpoints {
  static const double medium = 600;
  static const double expanded = 1024;
  static const double maxContentWidth = 1200;
}

extension ResponsiveContext on BuildContext {
  ScreenSize get screenSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width < Breakpoints.medium) {
      return ScreenSize.compact;
    }
    if (width < Breakpoints.expanded) {
      return ScreenSize.medium;
    }
    return ScreenSize.expanded;
  }

  bool get isCompact => screenSize == ScreenSize.compact;
  bool get isExpanded => screenSize == ScreenSize.expanded;

  double get pageGutter => switch (screenSize) {
        ScreenSize.compact => 16,
        ScreenSize.medium => 24,
        ScreenSize.expanded => 32,
      };

  double get sectionPadding => switch (screenSize) {
        ScreenSize.compact => 48,
        ScreenSize.medium => 64,
        ScreenSize.expanded => 96,
      };
}
