import 'package:flutter_test/flutter_test.dart';
import 'package:nexora_tech/features/admin/domain/enquiry.dart';
import 'package:nexora_tech/features/admin/domain/enquiry_status.dart';
import 'package:nexora_tech/features/enquiry/domain/service_interest.dart';

void main() {
  group('EnquiryStatus', () {
    test('maps database values and falls back to new', () {
      expect(EnquiryStatus.fromDbValue('in_progress'), EnquiryStatus.inProgress);
      expect(EnquiryStatus.fromDbValue('closed'), EnquiryStatus.closed);
      expect(EnquiryStatus.fromDbValue('unexpected'), EnquiryStatus.newEnquiry);
      expect(EnquiryStatus.fromDbValue(null), EnquiryStatus.newEnquiry);
    });
  });

  group('Enquiry.fromJson', () {
    test('reads every field', () {
      final enquiry = Enquiry.fromJson({
        'id': '11111111-1111-1111-1111-111111111111',
        'name': 'Ada',
        'email': 'name@example.com',
        'phone': null,
        'service_interest': 'ui_ux_design',
        'message': 'A message of sufficient length.',
        'status': 'in_progress',
        'internal_notes': 'Called back.',
        'created_at': '2026-11-07T10:00:00+00:00',
        'updated_at': '2026-11-07T11:00:00+00:00',
      });
      expect(enquiry.name, 'Ada');
      expect(enquiry.phone, isNull);
      expect(enquiry.serviceInterest, ServiceInterest.uiUxDesign);
      expect(enquiry.status, EnquiryStatus.inProgress);
      expect(enquiry.internalNotes, 'Called back.');
      expect(enquiry.createdAt.isBefore(enquiry.updatedAt), isTrue);
    });
  });
}
