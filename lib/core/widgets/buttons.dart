import 'package:flutter/material.dart';

import '../theme/brand_colors.dart';

/// The single most important action in a view (Electric Blue).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: BrandColors.white,
              ),
            )
          : Text(label),
    );
  }
}

/// Secondary action. Use [onDark] on Midnight Navy surfaces.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.onDark = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: onDark
          ? OutlinedButton.styleFrom(
              foregroundColor: BrandColors.white,
              side: const BorderSide(color: BrandColors.silver),
            )
          : null,
      child: Text(label),
    );
  }
}
