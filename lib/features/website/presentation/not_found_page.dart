import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/section.dart';
import '../../../core/widgets/site_scaffold.dart';
import 'widgets/page_header.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      title: 'Page not found | NEXORA TECH',
      currentPath: '',
      child: Column(
        children: [
          const PageHeader(
            title: 'Page not found',
            intro: 'The page you are looking for does not exist.',
          ),
          Section(
            child: Align(
              alignment: Alignment.centerLeft,
              child: PrimaryButton(
                label: 'Go to the home page',
                onPressed: () => context.go('/'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
