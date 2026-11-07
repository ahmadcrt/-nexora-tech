import 'service_interest.dart';

/// Validation rules for the enquiry form (NT-DOC-04 Section 6). The same
/// rules are enforced again by database constraints (FR-015).
abstract final class EnquiryValidators {
  static const int nameMin = 2;
  static const int nameMax = 100;
  static const int emailMax = 254;
  static const int phoneMax = 30;
  static const int messageMin = 10;
  static const int messageMax = 2000;

  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _phone = RegExp(r'^[0-9+\-\s]+$');

  static String? name(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return 'Enter your name.';
    }
    if (text.length < nameMin) {
      return 'Your name must have at least $nameMin characters.';
    }
    if (text.length > nameMax) {
      return 'Your name must have no more than $nameMax characters.';
    }
    return null;
  }

  static String? email(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return 'Enter your email address.';
    }
    if (text.length > emailMax || !_email.hasMatch(text)) {
      return 'Enter an email address such as name@example.com.';
    }
    return null;
  }

  /// Phone is optional; an empty value is valid.
  static String? phone(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return null;
    }
    if (text.length > phoneMax || !_phone.hasMatch(text)) {
      return 'Use digits, spaces, plus or hyphen only, up to $phoneMax characters.';
    }
    return null;
  }

  static String? message(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return 'Enter a message.';
    }
    if (text.length < messageMin) {
      return 'Your message must have at least $messageMin characters.';
    }
    if (text.length > messageMax) {
      return 'Your message must have no more than $messageMax characters.';
    }
    return null;
  }

  static String? service(ServiceInterest? value) {
    return value == null ? 'Choose a service.' : null;
  }

  static String? consent(bool value) {
    return value ? null : 'Please confirm you agree before sending.';
  }
}
