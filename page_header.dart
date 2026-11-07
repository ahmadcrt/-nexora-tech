import 'package:flutter/material.dart';

import '../../../../core/theme/brand_colors.dart';
import '../../../../core/theme/responsive_text.dart';
import '../../../../core/widgets/section.dart';

/// Midnight Navy band with the page title, used at the top of inner pages.
class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, this.intro});

  final String title;
  final String? intro;

  @override
  Widget build(BuildContext context) {
    return Section(
      background: BrandColors.midnightNavy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              title,
              style: context.h1Style.copyWith(color: BrandColors.white),
            ),
          ),
          if (intro != null) ...[
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                intro!,
                style: context.leadStyle.copyWith(color: BrandColors.silver),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
