import 'package:flutter/material.dart';

import '../theme/brand_colors.dart';
import '../theme/responsive_text.dart';

/// Message with an icon and text, so meaning never depends on colour alone.
class Notice extends StatelessWidget {
  const Notice({
    super.key,
    required this.icon,
    required this.title,
    this.message,
  });

  final IconData icon;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BrandColors.silverSoft,
          borderRadius: BorderRadius.circular(10),
          border: const Border(
            left: BorderSide(color: BrandColors.electricBlue, width: 4),
            top: BorderSide(color: BrandColors.silver),
            right: BorderSide(color: BrandColors.silver),
            bottom: BorderSide(color: BrandColors.silver),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: BrandColors.midnightNavy),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.bodyStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: BrandColors.midnightNavy,
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 4),
                    Text(message!, style: context.bodyStyle),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
