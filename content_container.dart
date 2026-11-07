import 'package:flutter/material.dart';

import '../theme/breakpoints.dart';

/// Centres content, limits its width and applies the responsive gutter.
class ContentContainer extends StatelessWidget {
  const ContentContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.pageGutter),
          child: child,
        ),
      ),
    );
  }
}
