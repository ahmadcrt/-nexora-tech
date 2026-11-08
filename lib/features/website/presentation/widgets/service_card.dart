import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/brand_colors.dart';
import '../../../../core/theme/responsive_text.dart';
import '../../content/site_content.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service, this.showAction = true});

  final ServiceInfo service;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 220),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: BrandColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BrandColors.silver),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(service.icon, size: 32, color: BrandColors.electricBlue),
          ),
          const SizedBox(height: 16),
          Text(
            service.name,
            style: context.h3Style.copyWith(color: BrandColors.midnightNavy),
          ),
          const SizedBox(height: 8),
          Text(service.summary, style: context.bodyStyle),
          if (showAction) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  context.go('/contact?service=${service.id}'),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text('Enquire about ${service.name}'),
            ),
          ],
        ],
      ),
    );
  }
}
