import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexora_tech/features/enquiry/application/enquiry_controller.dart';
import 'package:nexora_tech/features/enquiry/domain/enquiry_draft.dart';
import 'package:nexora_tech/features/enquiry/domain/enquiry_repository.dart';
import 'package:nexora_tech/features/enquiry/domain/service_interest.dart';

class _FakeRepository implements EnquiryRepository {
  _FakeRepository(this.outcome, {this.gate});

  final EnquirySubmitOutcome outcome;
  final Completer<void>? gate;
  int calls = 0;

  @override
  Future<EnquirySubmitOutcome> submit(EnquiryDraft draft) async {
    calls++;
    await gate?.future;
    return outcome;
  }
}

const _draft = EnquiryDraft(
  name: 'Ada',
  email: 'name@example.com',
  serviceInterest: ServiceInterest.other,
  message: 'A message of sufficient length.',
  consentGiven: true,
);

ProviderContainer _container(EnquiryRepository repository) {
  final container = ProviderContainer(
    overrides: [enquiryRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('starts idle', () {
    final container = _container(_FakeRepository(EnquirySubmitOutcome.success));
    expect(container.read(enquiryControllerProvider).phase,
        SubmissionPhase.idle);
  });

  test('reports success, failure and unavailable outcomes', () async {
    for (final entry in {
      EnquirySubmitOutcome.success: SubmissionPhase.success,
      EnquirySubmitOutcome.failure: SubmissionPhase.failure,
      EnquirySubmitOutcome.unavailable: SubmissionPhase.unavailable,
    }.entries) {
      final container = _container(_FakeRepository(entry.key));
      await container.read(enquiryControllerProvider.notifier).submit(_draft);
      expect(container.read(enquiryControllerProvider).phase, entry.value);
    }
  });

  test('ignores a second submit while one is in progress (FR-021)', () async {
    final gate = Completer<void>();
    final repository =
        _FakeRepository(EnquirySubmitOutcome.success, gate: gate);
    final container = _container(repository);
    final controller = container.read(enquiryControllerProvider.notifier);

    final first = controller.submit(_draft);
    final second = controller.submit(_draft);
    gate.complete();
    await first;
    await second;

    expect(repository.calls, 1);
  });

  test('reset returns to idle', () async {
    final container = _container(_FakeRepository(EnquirySubmitOutcome.success));
    final controller = container.read(enquiryControllerProvider.notifier);
    await controller.submit(_draft);
    controller.reset();
    expect(container.read(enquiryControllerProvider).phase,
        SubmissionPhase.idle);
  });
}
