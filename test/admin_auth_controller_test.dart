import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexora_tech/features/admin/application/admin_auth_controller.dart';
import 'package:nexora_tech/features/admin/application/admin_providers.dart';
import 'package:nexora_tech/features/admin/domain/admin_repository.dart';
import 'package:nexora_tech/features/admin/domain/enquiry.dart';
import 'package:nexora_tech/features/admin/domain/enquiry_status.dart';

class _FakeAdminRepository implements AdminRepository {
  _FakeAdminRepository({
    this.configured = true,
    this.admin = true,
    this.failSignIn = false,
  });

  final bool configured;
  final bool admin;
  final bool failSignIn;
  int signOutCalls = 0;

  @override
  bool get isConfigured => configured;

  @override
  bool get hasSession => false;

  @override
  Future<void> signIn({required String email, required String password}) async {
    if (failSignIn) {
      throw const AdminAccessException('bad credentials');
    }
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
  }

  @override
  Future<bool> isCurrentUserAdmin() async => admin;

  @override
  Future<List<Enquiry>> listEnquiries({
    EnquiryStatus? status,
    String search = '',
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Enquiry> getEnquiry(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateEnquiry(
    String id, {
    required EnquiryStatus status,
    required String internalNotes,
  }) {
    throw UnimplementedError();
  }
}

ProviderContainer _container(AdminRepository repository) {
  final container = ProviderContainer(
    overrides: [adminRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('is unconfigured when the backend is not connected', () {
    final container = _container(_FakeAdminRepository(configured: false));
    expect(container.read(adminAuthProvider).status,
        AdminAuthStatus.unconfigured);
  });

  test('starts signed out when configured and no session exists', () {
    final container = _container(_FakeAdminRepository());
    expect(container.read(adminAuthProvider).status, AdminAuthStatus.signedOut);
  });

  test('signs in an administrator', () async {
    final container = _container(_FakeAdminRepository());
    await container
        .read(adminAuthProvider.notifier)
        .signIn(email: 'a@example.com', password: 'secret');
    expect(container.read(adminAuthProvider).status, AdminAuthStatus.signedIn);
  });

  test('rejects a valid user without the admin role and signs them out',
      () async {
    final repository = _FakeAdminRepository(admin: false);
    final container = _container(repository);
    await container
        .read(adminAuthProvider.notifier)
        .signIn(email: 'a@example.com', password: 'secret');
    expect(container.read(adminAuthProvider).status,
        AdminAuthStatus.notAuthorised);
    expect(repository.signOutCalls, 1);
  });

  test('reports a generic message when sign-in fails', () async {
    final container = _container(_FakeAdminRepository(failSignIn: true));
    await container
        .read(adminAuthProvider.notifier)
        .signIn(email: 'a@example.com', password: 'wrong');
    final state = container.read(adminAuthProvider);
    expect(state.status, AdminAuthStatus.signedOut);
    expect(state.message, isNotNull);
  });

  test('sign out returns to the signed out state', () async {
    final container = _container(_FakeAdminRepository());
    final controller = container.read(adminAuthProvider.notifier);
    await controller.signIn(email: 'a@example.com', password: 'secret');
    await controller.signOut();
    expect(container.read(adminAuthProvider).status, AdminAuthStatus.signedOut);
  });
}
