import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_providers.dart';

enum AdminAuthStatus {
  /// The build has no Supabase configuration.
  unconfigured,

  /// Signing in or verifying a stored session.
  checking,
  signedOut,

  /// Signed in and confirmed to have the admin role.
  signedIn,

  /// Signed in with valid credentials but without the admin role.
  notAuthorised,
}

class AdminAuthState {
  const AdminAuthState(this.status, {this.message});

  final AdminAuthStatus status;
  final String? message;
}

/// Administrator sign-in state. Access is enforced by the database (Row Level
/// Security); this controller only decides what the interface shows.
class AdminAuthController extends Notifier<AdminAuthState> {
  @override
  AdminAuthState build() {
    final repository = ref.read(adminRepositoryProvider);
    if (!repository.isConfigured) {
      return const AdminAuthState(AdminAuthStatus.unconfigured);
    }
    if (repository.hasSession) {
      unawaited(Future<void>.microtask(_verifyStoredSession));
      return const AdminAuthState(AdminAuthStatus.checking);
    }
    return const AdminAuthState(AdminAuthStatus.signedOut);
  }

  Future<void> _verifyStoredSession() async {
    final repository = ref.read(adminRepositoryProvider);
    try {
      if (await repository.isCurrentUserAdmin()) {
        state = const AdminAuthState(AdminAuthStatus.signedIn);
        return;
      }
      await repository.signOut();
      state = const AdminAuthState(
        AdminAuthStatus.notAuthorised,
        message: 'This account does not have access to this area.',
      );
    } on Exception {
      state = const AdminAuthState(
        AdminAuthStatus.signedOut,
        message: 'Your session has ended. Please sign in again.',
      );
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    final repository = ref.read(adminRepositoryProvider);
    state = const AdminAuthState(AdminAuthStatus.checking);
    try {
      await repository.signIn(email: email, password: password);
      if (await repository.isCurrentUserAdmin()) {
        state = const AdminAuthState(AdminAuthStatus.signedIn);
        return;
      }
      await repository.signOut();
      state = const AdminAuthState(
        AdminAuthStatus.notAuthorised,
        message: 'This account does not have access to this area.',
      );
    } on Exception {
      // One message for every failure, so it never reveals which accounts exist.
      state = const AdminAuthState(
        AdminAuthStatus.signedOut,
        message: 'Sign-in failed. Check your email and password and try again.',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await ref.read(adminRepositoryProvider).signOut();
    } on Exception {
      // The local state is cleared even if the network call fails.
    }
    state = const AdminAuthState(AdminAuthStatus.signedOut);
  }
}

final adminAuthProvider =
    NotifierProvider<AdminAuthController, AdminAuthState>(
  AdminAuthController.new,
);
