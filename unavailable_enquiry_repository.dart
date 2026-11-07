import '../domain/enquiry_draft.dart';
import '../domain/enquiry_repository.dart';

/// Used when Supabase has not been configured for this build.
class UnavailableEnquiryRepository implements EnquiryRepository {
  const UnavailableEnquiryRepository();

  @override
  Future<EnquirySubmitOutcome> submit(EnquiryDraft draft) async {
    return EnquirySubmitOutcome.unavailable;
  }
}
