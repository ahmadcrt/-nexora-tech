import 'enquiry.dart';
import 'enquiry_status.dart';

/// Thrown when the backend refuses or silently ignores an administrator
/// action (for example when Row Level Security blocks it).
class AdminAccessException implements Exception {
  const AdminAccessException([this.message]);

  final String? message;

  @override
  String toString() => 'AdminAccessException: ${message ?? 'access denied'}';
}

/// Administrator operations. The UI depends only on this interface; the
/// Supabase implementation lives in the data layer.
abstract interface class AdminRepository {
  /// False when the build has no Supabase configuration.
  bool get isConfigured;

  /// True when a stored session exists (it still has to be verified).
  bool get hasSession;

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();

  /// True only when the signed-in user has the `admin` role in `profiles`.
  Future<bool> isCurrentUserAdmin();

  Future<List<Enquiry>> listEnquiries({
    EnquiryStatus? status,
    String search = '',
  });

  Future<Enquiry> getEnquiry(String id);

  /// Changes only the handling fields (status and internal notes).
  Future<void> updateEnquiry(
    String id, {
    required EnquiryStatus status,
    required String internalNotes,
  });
}
