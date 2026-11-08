import 'package:flutter/material.dart';

/// Approved logo variants (decision D-006). The files are exports of the
/// approved logo system; they must not be redrawn, recoloured or stretched.
enum LogoVariant { horizontal, stacked, symbol, wordmark }

/// [onLight] uses the navy and blue artwork; [onDark] uses white and blue.
enum LogoTone { onLight, onDark }

class NexoraLogo extends StatelessWidget {
  const NexoraLogo({
    super.key,
    this.variant = LogoVariant.horizontal,
    this.tone = LogoTone.onLight,
    required this.height,
  });

  final LogoVariant variant;
  final LogoTone tone;

  /// Height in logical pixels. Width follows the artwork's proportions.
  final double height;

  String get _asset {
    final name = switch (variant) {
      LogoVariant.horizontal => 'horizontal',
      LogoVariant.stacked => 'stacked',
      LogoVariant.symbol => 'symbol',
      LogoVariant.wordmark => 'wordmark',
    };
    final suffix = tone == LogoTone.onDark ? 'dark' : 'light';
    return 'assets/images/logo/nexora-$name-$suffix.png';
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _asset,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'NEXORA TECH',
    );
  }
}
