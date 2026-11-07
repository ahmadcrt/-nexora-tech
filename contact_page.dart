import 'package:flutter/material.dart';

import '../../../core/widgets/section.dart';
import '../../../core/widgets/site_scaffold.dart';
import '../../website/presentation/widgets/page_header.dart';
import '../domain/service_interest.dart';
import 'enquiry_form.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key, this.initialService});

  /// Pre-selected service, from the `service` query parameter.
  final ServiceInterest? initialService;

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      title: 'Contact | NEXORA TECH',
      currentPath: '/contact',
      child: Column(
        children: [
          const PageHeader(
            title: 'Contact us',
            intro: 'Send us an enquiry about your project.',
          ),
          Section(
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: EnquiryForm(initialService: initialService),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
