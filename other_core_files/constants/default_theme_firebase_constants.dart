class DefaultThemeConstants {
  DefaultThemeConstants._internal();

  static final DefaultThemeConstants _instance =
      DefaultThemeConstants._internal();

  factory DefaultThemeConstants() {
    return _instance;
  }

  static const String marcomOrganizationId = "1";
  static const String primaryColor = '#587a6f';
  static const String secondaryColor = '#FF9800';
  static const Map<String, String> primaryColorSwatch = {
    "50": "#e0e6e4",
    "100": "#b3c2bd",
    "200": "#809b94",
    "300": "#4d746b",
    "400": "#265b51",
    "500": "#587a6f",
    "600": "#507267",
    "700": "#46675c",
    "800": "#3d5d52",
    "900": "#2e4d40",
  };

  static const String logoUrl =
      'https://via.placeholder.com/200x200/587a6f/FFFFFF?text=LOGO';
  static const String bannerUrl =
      'https://via.placeholder.com/800x200/587a6f/FFFFFF?text=BANNER';
  static const String companyName = 'Marcom';

  static const String fontFamily = 'Roboto';
}
