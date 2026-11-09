import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/app_config.dart';
import '../data/supabase_enquiry_repository.dart';
import '../data/unavailable_enquiry_repository.dart';
import '../domain/enquiry_draft.dart';
import '../domain/enquiry_repository.dart';

final enquiryRepositoryProvider = Provider<EnquiryRepository>((ref) {
  // Public enquiries are off unless Supabase is configured and the
  // ENQUIRIES_ENABLED switch was set at build time.
  if (!AppConfig.publicEnquiriesActive) {
    return const UnavailableEnquiryRepository();
  }
  return SupabaseEnquiryRepository(Supabase.instance.client);
});

enum SubmissionPhase {
  idle,
  submitting,
  success,
  unavailable,
  rateLimited,
  failure,
}

class EnquiryState {
  const EnquiryState({this.phase = SubmissionPhase.idle});

  final SubmissionPhase phase;

  bool get isSubmitting => phase == SubmissionPhase.submitting;
}

class EnquiryController extends Notifier<EnquiryState> {
  @override
  EnquiryState build() => const EnquiryState();

  Future<void> submit(EnquiryDraft draft) async {
    // Guards against double submission (FR-021).
    if (state.isSubmitting) {
      return;
    }
    state = const EnquiryState(phase: SubmissionPhase.submitting);
    final outcome = await ref.read(enquiryRepositoryProvider).submit(draft);
    state = EnquiryState(
      phase: switch (outcome) {
        EnquirySubmitOutcome.success => SubmissionPhase.success,
        EnquirySubmitOutcome.unavailable => SubmissionPhase.unavailable,
        EnquirySubmitOutcome.rateLimited => SubmissionPhase.rateLimited,
        EnquirySubmitOutcome.failure => SubmissionPhase.failure,
      },
    );
  }

  void reset() {
    state = const EnquiryState();
  }
}

final enquiryControllerProvider =
    NotifierProvider<EnquiryController, EnquiryState>(EnquiryController.new);
