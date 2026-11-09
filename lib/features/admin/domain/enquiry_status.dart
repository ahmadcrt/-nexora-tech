/// Handling state of an enquiry. [dbValue] matches the PostgreSQL
/// `enquiry_status` type (NT-DOC-07 Section 5).
enum EnquiryStatus {
  newEnquiry('new', 'New'),
  inProgress('in_progress', 'In progress'),
  closed('closed', 'Closed');

  const EnquiryStatus(this.dbValue, this.label);

  final String dbValue;
  final String label;

  /// Unknown values fall back to [newEnquiry] so the list never fails to load.
  static EnquiryStatus fromDbValue(String? value) {
    for (final item in EnquiryStatus.values) {
      if (item.dbValue == value) {
        return item;
      }
    }
    return EnquiryStatus.newEnquiry;
  }
}
