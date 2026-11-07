import 'package:flutter/material.dart';

import '../theme/brand_colors.dart';
import '../theme/breakpoints.dart';
import 'site_footer.dart';
import 'site_header.dart';

/// Shared page frame: header, scrolling body and footer.
///
/// The footer sits at the bottom of the window on short pages.
class SiteScaffold extends StatelessWidget {
  const SiteScaffold({
    super.key,
    required this.title,
    required this.currentPath,
    required this.child,
  });

  /// Browser tab title.
  final String title;
  final String currentPath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Title(
      title: title,
      color: BrandColors.midnightNavy,
      child: Scaffold(
        endDrawer: context.isExpanded ? null : NavDrawer(currentPath: currentPath),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SiteHeader(currentPath: currentPath),
                        child,
                      ],
                    ),
                    const SiteFooter(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
