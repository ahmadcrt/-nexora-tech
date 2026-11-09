import 'enquiry_draft.dart';

enum EnquirySubmitOutcome { success, unavailable, rateLimited, failure }

/// Stores enquiries. Implementations live in the data layer; the rest of the
/// application depends only on this interface.
abstract interface class EnquiryRepository {
  Future<EnquirySubmitOutcome> submit(EnquiryDraft draft);
}
