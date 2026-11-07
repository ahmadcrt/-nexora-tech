import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/brand_colors.dart';
import '../../../../core/theme/responsive_text.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/section.dart';

class ClosingCta extends StatelessWidget {
  const ClosingCta({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      background: BrandColors.graphite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              'Have a project in mind?',
              style: context.h2Style.copyWith(color: BrandColors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tell us what you need.',
            style: context.leadStyle.copyWith(color: BrandColors.silver),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Contact us',
            onPressed: () => context.go('/contact'),
          ),
        ],
      ),
    );
  }
}
