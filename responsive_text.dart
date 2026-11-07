import 'package:flutter/material.dart';

import 'breakpoints.dart';

/// Responsive type styles from NT-DOC-08 Section 5.
extension ResponsiveTextStyles on BuildContext {
  TextTheme get _text => Theme.of(this).textTheme;

  TextStyle get displayStyle =>
      isCompact ? _text.displayMedium! : _text.displayLarge!;
  TextStyle get h1Style =>
      isCompact ? _text.headlineMedium! : _text.headlineLarge!;
  TextStyle get h2Style => isCompact ? _text.titleLarge! : _text.headlineSmall!;
  TextStyle get h3Style => _text.titleMedium!;
  TextStyle get bodyStyle => _text.bodyMedium!;
  TextStyle get leadStyle => _text.bodyLarge!;
  TextStyle get smallStyle => _text.bodySmall!;
}
