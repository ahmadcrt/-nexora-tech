import 'package:flutter/material.dart';

import '../../../core/widgets/responsive_grid.dart';
import '../../../core/widgets/section.dart';
import '../../../core/widgets/site_scaffold.dart';
import '../content/site_content.dart';
import 'widgets/closing_cta.dart';
import 'widgets/page_header.dart';
import 'widgets/service_card.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      title: 'Services | NEXORA TECH',
      currentPath: '/services',
      child: Column(
        children: [
          const PageHeader(
            title: 'Services',
            intro: 'Technology and design services for businesses.',
          ),
          Section(
            child: ResponsiveGrid(
              children: [
                for (final service in SiteContent.services)
                  ServiceCard(service: service),
              ],
            ),
          ),
          const ClosingCta(),
        ],
      ),
    );
  }
}
