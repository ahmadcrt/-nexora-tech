import 'package:flutter_test/flutter_test.dart';
import 'package:nexora_tech/features/enquiry/domain/enquiry_draft.dart';
import 'package:nexora_tech/features/enquiry/domain/enquiry_validators.dart';
import 'package:nexora_tech/features/enquiry/domain/service_interest.dart';

void main() {
  group('EnquiryValidators.name', () {
    test('rejects empty and too short names', () {
      expect(EnquiryValidators.name(''), isNotNull);
      expect(EnquiryValidators.name('  '), isNotNull);
      expect(EnquiryValidators.name('A'), isNotNull);
    });

    test('accepts a normal name and rejects one over 100 characters', () {
      expect(EnquiryValidators.name('Ada'), isNull);
      expect(EnquiryValidators.name('A' * 101), isNotNull);
    });
  });

  group('EnquiryValidators.email', () {
    test('rejects invalid addresses', () {
      expect(EnquiryValidators.email(''), isNotNull);
      expect(EnquiryValidators.email('not-an-email'), isNotNull);
      expect(EnquiryValidators.email('a@b'), isNotNull);
      expect(EnquiryValidators.email('a b@example.com'), isNotNull);
    });

    test('accepts a valid address', () {
      expect(EnquiryValidators.email('name@example.com'), isNull);
    });
  });

  group('EnquiryValidators.phone', () {
    test('is optional', () {
      expect(EnquiryValidators.phone(null), isNull);
      expect(EnquiryValidators.phone(''), isNull);
    });

    test('allows digits, spaces, plus and hyphen only', () {
      expect(EnquiryValidators.phone('+1 234-567 890'), isNull);
      expect(EnquiryValidators.phone('call me'), isNotNull);
      expect(EnquiryValidators.phone('1' * 31), isNotNull);
    });
  });

  group('EnquiryValidators.message', () {
    test('enforces 10 to 2000 characters', () {
      expect(EnquiryValidators.message('short'), isNotNull);
      expect(EnquiryValidators.message('This is long enough.'), isNull);
      expect(EnquiryValidators.message('x' * 2001), isNotNull);
    });
  });

  group('EnquiryValidators service and consent', () {
    test('service is required', () {
      expect(EnquiryValidators.service(null), isNotNull);
      expect(EnquiryValidators.service(ServiceInterest.other), isNull);
    });

    test('consent must be given', () {
      expect(EnquiryValidators.consent(false), isNotNull);
      expect(EnquiryValidators.consent(true), isNull);
    });
  });

  group('EnquiryDraft.toInsertJson', () {
    test('trims values, nulls an empty phone and sends no system fields', () {
      const draft = EnquiryDraft(
        name: '  Ada  ',
        email: ' name@example.com ',
        phone: '   ',
        serviceInterest: ServiceInterest.uiUxDesign,
        message: '  A message of sufficient length.  ',
        consentGiven: true,
      );
      final json = draft.toInsertJson();
      expect(json['name'], 'Ada');
      expect(json['email'], 'name@example.com');
      expect(json['phone'], isNull);
      expect(json['service_interest'], 'ui_ux_design');
      expect(json['message'], 'A message of sufficient length.');
      expect(json['consent_given'], true);
      expect(json.containsKey('status'), isFalse);
      expect(json.containsKey('internal_notes'), isFalse);
    });
  });

  group('ServiceInterest', () {
    test('maps database values back to the enum', () {
      expect(ServiceInterest.fromDbValue('graphic_design'),
          ServiceInterest.graphicDesign);
      expect(ServiceInterest.fromDbValue('unknown'), isNull);
      expect(ServiceInterest.fromDbValue(null), isNull);
    });
  });
}
