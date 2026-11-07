import 'package:flutter/material.dart';

import '../theme/breakpoints.dart';
import '../theme/brand_colors.dart';
import 'content_container.dart';

/// A full-width band with a background colour and constrained content.
class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.child,
    this.background = BrandColors.white,
  });

  final Widget child;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: background,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.sectionPadding),
        child: ContentContainer(child: child),
      ),
    );
  }
}
