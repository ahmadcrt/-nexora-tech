import 'package:flutter/material.dart';

import '../../../core/widgets/notice.dart';
import '../../../core/widgets/section.dart';
import '../../../core/widgets/site_scaffold.dart';
import 'widgets/page_header.dart';

/// Placeholder for the privacy notice and terms.
///
/// The wording must be prepared with qualified legal advice (TBD-009) and is
/// deliberately not written here.
class LegalPlaceholderPage extends StatelessWidget {
  const LegalPlaceholderPage({
    super.key,
    required this.title,
    required this.path,
  });

  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      title: '$title | NEXORA TECH',
      currentPath: path,
      child: Column(
        children: [
          PageHeader(title: title),
          const Section(
            child: Notice(
              icon: Icons.info_outline,
              title: 'This page is being prepared.',
              message: 'It will be published before online enquiries open.',
            ),
          ),
        ],
      ),
    );
  }
}
