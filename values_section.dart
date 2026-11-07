import 'package:flutter/material.dart';

import '../../../../core/theme/brand_colors.dart';
import '../../../../core/theme/responsive_text.dart';
import '../../../../core/widgets/section.dart';
import '../../content/site_content.dart';

/// The eight approved core values (D-004).
class ValuesSection extends StatelessWidget {
  const ValuesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      background: BrandColors.silverSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              'Our values',
              style: context.h2Style.copyWith(color: BrandColors.midnightNavy),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final value in SiteContent.values)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: BrandColors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: BrandColors.silver),
                  ),
                  child: Text(
                    value,
                    style: context.bodyStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      color: BrandColors.midnightNavy,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
