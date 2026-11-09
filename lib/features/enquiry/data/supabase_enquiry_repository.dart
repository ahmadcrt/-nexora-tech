import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/enquiry_draft.dart';
import '../domain/enquiry_repository.dart';

/// Stores enquiries in the Supabase `enquiries` table.
class SupabaseEnquiryRepository implements EnquiryRepository {
  const SupabaseEnquiryRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<EnquirySubmitOutcome> submit(EnquiryDraft draft) async {
    try {
      // Visitors may insert but not read (NT-DOC-07 Section 7), so the call
      // must not ask for the inserted row back (no select).
      await _client.from('enquiries').insert(draft.toInsertJson());
      return EnquirySubmitOutcome.success;
    } on PostgrestException catch (error) {
      // The database rejects bursts with a 'rate_limit_*' message.
      if (error.message.contains('rate_limit')) {
        return EnquirySubmitOutcome.rateLimited;
      }
      return EnquirySubmitOutcome.failure;
    } on Exception {
      return EnquirySubmitOutcome.failure;
    }
  }
}
