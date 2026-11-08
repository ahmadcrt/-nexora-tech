import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/nav_items.dart';
import '../theme/breakpoints.dart';
import '../theme/brand_colors.dart';
import '../theme/responsive_text.dart';
import 'content_container.dart';
import 'nexora_logo.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NexoraLogo(tone: LogoTone.onDark, height: 40),
        const SizedBox(height: 16),
        Text(
          'Technology That Moves Business Forward.',
          style: context.bodyStyle.copyWith(color: BrandColors.silver),
        ),
        const SizedBox(height: 8),
        Text(
          'A remote-first technology company.',
          style: context.smallStyle.copyWith(color: BrandColors.silver),
        ),
      ],
    );
    final company = _LinkColumn(
      title: 'Company',
      items: const [NavItems.services, NavItems.about, NavItems.contact],
    );
    final legal = _LinkColumn(
      title: 'Legal',
      items: const [NavItems.privacy, NavItems.terms],
    );

    return Material(
      color: BrandColors.midnightNavy,
      child: ContentContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (context.isExpanded)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: brand),
                    Expanded(child: company),
                    Expanded(child: legal),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    brand,
                    const SizedBox(height: 32),
                    company,
                    const SizedBox(height: 24),
                    legal,
                  ],
                ),
              const SizedBox(height: 32),
              const Divider(color: BrandColors.graphite, height: 1),
              const SizedBox(height: 16),
              Text(
                '\u00A9 ${DateTime.now().year} NEXORA TECH',
                style: context.smallStyle.copyWith(color: BrandColors.silver),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkColumn extends StatelessWidget {
  const _LinkColumn({required this.title, required this.items});

  final String title;
  final List<NavItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.bodyStyle.copyWith(
            color: BrandColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        for (final item in items)
          TextButton(
            onPressed: () => context.go(item.path),
            style: TextButton.styleFrom(
              foregroundColor: BrandColors.silver,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
            ),
            child: Text(item.label),
          ),
      ],
    );
  }
}
