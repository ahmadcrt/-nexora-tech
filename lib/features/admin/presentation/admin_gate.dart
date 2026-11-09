import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/notice.dart';
import '../application/admin_auth_controller.dart';
import 'admin_sign_in_view.dart';

/// Shows [builder] only to a signed-in administrator. Everyone else sees the
/// sign-in form. The database enforces access; this only controls the view.
class AdminGate extends ConsumerWidget {
  const AdminGate({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(adminAuthProvider);
    switch (auth.status) {
      case AdminAuthStatus.unconfigured:
        return const Notice(
          icon: Icons.info_outline,
          title: 'Administration is not available yet.',
          message: 'The backend is not connected to this version of the website.',
        );
      case AdminAuthStatus.checking:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        );
      case AdminAuthStatus.signedOut:
      case AdminAuthStatus.notAuthorised:
        return AdminSignInView(message: auth.message);
      case AdminAuthStatus.signedIn:
        return builder(context);
    }
  }
}
