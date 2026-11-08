import 'package:flutter/material.dart';

import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/responsive_text.dart';
import '../../../core/widgets/section.dart';
import '../../../core/widgets/site_scaffold.dart';
import '../content/site_content.dart';
import 'widgets/closing_cta.dart';
import 'widgets/page_header.dart';
import 'widgets/values_section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      title: 'About | NEXORA TECH',
      currentPath: '/about',
      child: Column(
        children: [
          const PageHeader(title: 'About NEXORA TECH'),
          Section(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${SiteContent.intro} The company was founded by '
                        '${SiteContent.founderName}, '
                        '${SiteContent.founderTitle}.',
                        style: context.leadStyle,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        SiteContent.tagline,
                        style: context.h3Style
                            .copyWith(color: BrandColors.midnightNavy),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: BrandColors.silver),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SiteContent.founderName,
                        style: context.h3Style
                            .copyWith(color: BrandColors.midnightNavy),
                      ),
                      Text(SiteContent.founderTitle, style: context.bodyStyle),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const ValuesSection(),
          const ClosingCta(),
        ],
      ),
    );
  }
}
