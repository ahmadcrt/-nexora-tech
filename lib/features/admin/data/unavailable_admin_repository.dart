import '../domain/admin_repository.dart';
import '../domain/enquiry.dart';
import '../domain/enquiry_status.dart';

/// Used when Supabase has not been configured for this build.
class UnavailableAdminRepository implements AdminRepository {
  const UnavailableAdminRepository();

  @override
  bool get isConfigured => false;

  @override
  bool get hasSession => false;

  @override
  Future<void> signIn({required String email, required String password}) {
    throw const AdminAccessException('Backend not configured.');
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<bool> isCurrentUserAdmin() async => false;

  @override
  Future<List<Enquiry>> listEnquiries({
    EnquiryStatus? status,
    String search = '',
  }) {
    throw const AdminAccessException('Backend not configured.');
  }

  @override
  Future<Enquiry> getEnquiry(String id) {
    throw const AdminAccessException('Backend not configured.');
  }

  @override
  Future<void> updateEnquiry(
    String id, {
    required EnquiryStatus status,
    required String internalNotes,
  }) {
    throw const AdminAccessException('Backend not configured.');
  }
}
