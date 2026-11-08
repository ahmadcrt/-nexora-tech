import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/breakpoints.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/theme/responsive_text.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/nexora_logo.dart';
import '../../../../core/widgets/section.dart';
import '../../content/site_content.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            SiteContent.tagline,
            style: context.displayStyle.copyWith(color: BrandColors.white),
          ),
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            SiteContent.intro,
            style: context.leadStyle.copyWith(color: BrandColors.silver),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            PrimaryButton(
              label: 'Contact us',
              onPressed: () => context.go('/contact'),
            ),
            SecondaryButton(
              label: 'Our services',
              onDark: true,
              onPressed: () => context.go('/services'),
            ),
          ],
        ),
      ],
    );

    return Section(
      background: BrandColors.midnightNavy,
      child: context.isExpanded
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: text),
                const SizedBox(width: 64),
                const Expanded(
                  flex: 2,
                  child: Center(
                    child: ExcludeSemantics(
                      child: NexoraLogo(
                        variant: LogoVariant.symbol,
                        tone: LogoTone.onDark,
                        height: 260,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : text,
    );
  }
}
