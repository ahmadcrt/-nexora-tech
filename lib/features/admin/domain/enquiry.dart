import '../../enquiry/domain/service_interest.dart';
import 'enquiry_status.dart';

/// An enquiry as read by an administrator.
class Enquiry {
  const Enquiry({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.serviceInterest,
    required this.message,
    required this.status,
    this.internalNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      serviceInterest:
          ServiceInterest.fromDbValue(json['service_interest'] as String?),
      message: json['message'] as String,
      status: EnquiryStatus.fromDbValue(json['status'] as String?),
      internalNotes: json['internal_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  final String id;
  final String name;
  final String email;
  final String? phone;
  final ServiceInterest? serviceInterest;
  final String message;
  final EnquiryStatus status;
  final String? internalNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
