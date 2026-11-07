import 'package:flutter/material.dart';

/// A service NEXORA TECH offers.
class ServiceInfo {
  const ServiceInfo({
    required this.id,
    required this.name,
    required this.summary,
    required this.icon,
  });

  /// Matches the `service_interest` database value (NT-DOC-07 Section 5).
  final String id;
  final String name;
  final String summary;
  final IconData icon;
}

/// Public website copy.
///
/// Names of services and values are approved (D-003, D-004). The one-line
/// summaries are DRAFT COPY pending Founder approval (TBD-017); they describe
/// the service in general terms and make no claim about clients, results or
/// pricing. The scope of "Digital Solutions" is undecided (TBD-011).
abstract final class SiteContent {
  static const String tagline = 'Technology That Moves Business Forward.';

  static const String intro =
      'NEXORA TECH is a remote-first technology company serving businesses '
      'in Nigeria and across Africa.';

  static const String founderName = 'AHMAD YUNUSA';
  static const String founderTitle = 'Founder & CEO';

  static const List<ServiceInfo> services = [
    ServiceInfo(
      id: 'website_development',
      name: 'Website Development',
      summary:
          'Websites designed and built to present your business clearly online.',
      icon: Icons.language,
    ),
    ServiceInfo(
      id: 'software_development',
      name: 'Software Development',
      summary: 'Custom software built around the way your business works.',
      icon: Icons.code,
    ),
    ServiceInfo(
      id: 'ui_ux_design',
      name: 'UI/UX Design',
      summary:
          'Interfaces and experiences designed to be clear, usable and consistent.',
      icon: Icons.design_services,
    ),
    ServiceInfo(
      id: 'graphic_design',
      name: 'Graphic Design',
      summary: 'Visual design that supports your brand and communication.',
      icon: Icons.brush,
    ),
    ServiceInfo(
      id: 'digital_solutions',
      name: 'Digital Solutions',
      summary: 'Technology solutions shaped around your business needs.',
      icon: Icons.hub,
    ),
  ];

  static const List<String> values = [
    'Innovation',
    'Integrity',
    'Excellence',
    'Customer Focus',
    'Reliability',
    'Continuous Learning',
    'Collaboration',
    'Responsibility',
  ];
}
