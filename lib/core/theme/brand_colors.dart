import 'package:flutter/painting.dart';

/// Approved NEXORA TECH palette (decision D-006).
///
/// Do not add colours without an approved decision (see TBD-026 for status
/// colours).
abstract final class BrandColors {
  static const Color midnightNavy = Color(0xFF0B1220);
  static const Color electricBlue = Color(0xFF2563EB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color silver = Color(0xFFC7CED8);
  static const Color graphite = Color(0xFF202938);

  /// Silver at 25% over White. A derived surface tint, not a new brand
  /// colour; confirm in NT-DOC-08.
  static const Color silverSoft = Color(0xFFF1F3F5);
}
