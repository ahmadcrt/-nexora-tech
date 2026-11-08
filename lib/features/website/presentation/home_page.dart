import 'package:flutter/material.dart';

import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/responsive_text.dart';
import '../../../core/widgets/responsive_grid.dart';
import '../../../core/widgets/section.dart';
import '../../../core/widgets/site_scaffold.dart';
import '../content/site_content.dart';
import 'widgets/closing_cta.dart';
import 'widgets/hero_section.dart';
import 'widgets/service_card.dart';
import 'widgets/values_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      title: 'NEXORA TECH | ${SiteContent.tagline}',
      currentPath: '/',
      child: Column(
        children: [
          const HeroSection(),
          Section(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    'What we do',
                    style: context.h2Style
                        .copyWith(color: BrandColors.midnightNavy),
                  ),
                ),
                const SizedBox(height: 32),
                ResponsiveGrid(
                  children: [
                    for (final service in SiteContent.services)
                      ServiceCard(service: service),
                  ],
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
