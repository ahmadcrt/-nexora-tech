import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/admin_repository.dart';
import '../domain/enquiry.dart';
import '../domain/enquiry_status.dart';

/// Administrator operations on Supabase.
///
/// Every call runs with the signed-in user's token, so Row Level Security
/// decides what is allowed. The service-role key is never used here.
class SupabaseAdminRepository implements AdminRepository {
  const SupabaseAdminRepository(this._client);

  final SupabaseClient _client;

  static const int _maxRows = 200;

  @override
  bool get isConfigured => true;

  @override
  bool get hasSession => _client.auth.currentSession != null;

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Future<bool> isCurrentUserAdmin() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      return false;
    }
    final row = await _client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();
    return row != null && row['role'] == 'admin';
  }

  @override
  Future<List<Enquiry>> listEnquiries({
    EnquiryStatus? status,
    String search = '',
  }) async {
    var query = _client.from('enquiries').select();
    if (status != null) {
      query = query.eq('status', status.dbValue);
    }
    final term = _sanitiseSearch(search);
    if (term.isNotEmpty) {
      query = query.or('name.ilike.%$term%,email.ilike.%$term%');
    }
    final rows =
        await query.order('created_at', ascending: false).limit(_maxRows);
    return [for (final row in rows) Enquiry.fromJson(row)];
  }

  @override
  Future<Enquiry> getEnquiry(String id) async {
    final row = await _client.from('enquiries').select().eq('id', id).single();
    return Enquiry.fromJson(row);
  }

  @override
  Future<void> updateEnquiry(
    String id, {
    required EnquiryStatus status,
    required String internalNotes,
  }) async {
    final notes = internalNotes.trim();
    final rows = await _client
        .from('enquiries')
        .update({
          'status': status.dbValue,
          'internal_notes': notes.isEmpty ? null : notes,
        })
        .eq('id', id)
        .select('id');
    // Row Level Security reports a blocked update as "no rows changed".
    if (rows.isEmpty) {
      throw const AdminAccessException('The update was not applied.');
    }
  }

  /// Removes characters that have a meaning in the PostgREST filter syntax.
  static String _sanitiseSearch(String value) {
    final cleaned = value.replaceAll(RegExp(r'[,()%*\\"]'), ' ').trim();
    return cleaned.length > 100 ? cleaned.substring(0, 100) : cleaned;
  }
}
