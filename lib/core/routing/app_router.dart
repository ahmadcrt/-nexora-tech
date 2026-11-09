import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/admin_page.dart';
import '../../features/admin/presentation/enquiry_detail_page.dart';
import '../../features/enquiry/domain/service_interest.dart';
import '../../features/enquiry/presentation/contact_page.dart';
import '../../features/website/presentation/about_page.dart';
import '../../features/website/presentation/home_page.dart';
import '../../features/website/presentation/legal_placeholder_page.dart';
import '../../features/website/presentation/not_found_page.dart';
import '../../features/website/presentation/services_page.dart';

/// Path-based routes (ADR-003, proposed). The host must rewrite unknown paths
/// to the application entry file (NT-DOC-06 Section 9, TBD-007).
GoRouter createRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            const NoTransitionPage<void>(child: HomePage()),
      ),
      GoRoute(
        path: '/services',
        pageBuilder: (context, state) =>
            const NoTransitionPage<void>(child: ServicesPage()),
      ),
      GoRoute(
        path: '/about',
        pageBuilder: (context, state) =>
            const NoTransitionPage<void>(child: AboutPage()),
      ),
      GoRoute(
        path: '/contact',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          child: ContactPage(
            initialService: ServiceInterest.fromDbValue(
              state.uri.queryParameters['service'],
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/privacy',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: LegalPlaceholderPage(
            title: 'Privacy notice',
            path: '/privacy',
          ),
        ),
      ),
      GoRoute(
        path: '/terms',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: LegalPlaceholderPage(title: 'Terms', path: '/terms'),
        ),
      ),
      // Administration. Not linked from the public navigation.
      GoRoute(
        path: '/admin',
        pageBuilder: (context, state) =>
            const NoTransitionPage<void>(child: AdminPage()),
      ),
      GoRoute(
        path: '/admin/enquiries/:id',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          child: EnquiryDetailPage(id: state.pathParameters['id'] ?? ''),
        ),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
