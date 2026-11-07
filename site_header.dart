import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/nav_items.dart';
import '../theme/breakpoints.dart';
import '../theme/brand_colors.dart';
import 'buttons.dart';
import 'content_container.dart';
import 'nexora_logo.dart';

class SiteHeader extends StatelessWidget {
  const SiteHeader({super.key, required this.currentPath});

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    final showFullNav = context.isExpanded;
    return Material(
      color: BrandColors.midnightNavy,
      child: SafeArea(
        bottom: false,
        child: ContentContainer(
          child: SizedBox(
            height: 72,
            child: Row(
              children: [
                InkWell(
                  onTap: () => context.go(NavItems.home.path),
                  child: const NexoraLogo(
                    tone: LogoTone.onDark,
                    height: 36,
                  ),
                ),
                const Spacer(),
                if (showFullNav) ...[
                  for (final item in NavItems.header)
                    _NavLink(item: item, active: currentPath == item.path),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    label: 'Contact us',
                    onPressed: () => context.go(NavItems.contact.path),
                  ),
                ] else
                  IconButton(
                    tooltip: 'Open menu',
                    icon: const Icon(Icons.menu, color: BrandColors.white),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.item, required this.active});

  final NavItem item;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(item.path),
      style: TextButton.styleFrom(
        foregroundColor: BrandColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(
        item.label,
        style: TextStyle(
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          decoration: active ? TextDecoration.underline : TextDecoration.none,
          decorationColor: BrandColors.electricBlue,
          decorationThickness: 2,
        ),
      ),
    );
  }
}

/// Navigation drawer used below the expanded breakpoint.
class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key, required this.currentPath});

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: BrandColors.midnightNavy,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: NexoraLogo(tone: LogoTone.onDark, height: 36),
              ),
            ),
            for (final item in NavItems.drawer)
              ListTile(
                title: Text(
                  item.label,
                  style: const TextStyle(
                    color: BrandColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: currentPath == item.path,
                selectedTileColor: BrandColors.graphite,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(item.path);
                },
              ),
          ],
        ),
      ),
    );
  }
}
