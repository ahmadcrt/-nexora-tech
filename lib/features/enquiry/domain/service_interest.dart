/// Service a visitor is interested in. [dbValue] matches the PostgreSQL
/// `service_interest` type (NT-DOC-07 Section 5).
enum ServiceInterest {
  websiteDevelopment('website_development', 'Website Development'),
  softwareDevelopment('software_development', 'Software Development'),
  uiUxDesign('ui_ux_design', 'UI/UX Design'),
  graphicDesign('graphic_design', 'Graphic Design'),
  digitalSolutions('digital_solutions', 'Digital Solutions'),
  other('other', 'Other or not sure');

  const ServiceInterest(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static ServiceInterest? fromDbValue(String? value) {
    for (final item in ServiceInterest.values) {
      if (item.dbValue == value) {
        return item;
      }
    }
    return null;
  }
}
