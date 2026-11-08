import 'service_interest.dart';

/// An enquiry as entered by a visitor, before it is stored.
class EnquiryDraft {
  const EnquiryDraft({
    required this.name,
    required this.email,
    this.phone,
    required this.serviceInterest,
    required this.message,
    required this.consentGiven,
  });

  final String name;
  final String email;
  final String? phone;
  final ServiceInterest serviceInterest;
  final String message;
  final bool consentGiven;

  /// Column values for the `enquiries` table. System fields (status, notes,
  /// assignee, timestamps) are never sent by the client.
  Map<String, dynamic> toInsertJson() {
    final trimmedPhone = phone?.trim();
    return {
      'name': name.trim(),
      'email': email.trim(),
      'phone': (trimmedPhone == null || trimmedPhone.isEmpty)
          ? null
          : trimmedPhone,
      'service_interest': serviceInterest.dbValue,
      'message': message.trim(),
      'consent_given': consentGiven,
    };
  }
}
