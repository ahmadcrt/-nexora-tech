class NavItem {
  const NavItem(this.label, this.path);

  final String label;
  final String path;
}

abstract final class NavItems {
  /// Links shown in the header (Contact is shown as a button).
  static const List<NavItem> header = [
    NavItem('Services', '/services'),
    NavItem('About', '/about'),
  ];

  static const NavItem home = NavItem('Home', '/');
  static const NavItem services = NavItem('Services', '/services');
  static const NavItem about = NavItem('About', '/about');
  static const NavItem contact = NavItem('Contact', '/contact');
  static const NavItem privacy = NavItem('Privacy notice', '/privacy');
  static const NavItem terms = NavItem('Terms', '/terms');

  static const List<NavItem> drawer = [home, services, about, contact];
}
