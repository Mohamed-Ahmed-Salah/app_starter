import 'dart:convert';

import 'package:hive/hive.dart';

import '../constants/default_theme_firebase_constants.dart';

part 'organization_theme_config.g.dart';

@HiveType(typeId: 0)
class OrganizationThemeConfig extends HiveObject {
  @HiveField(0)
  String organizationId;

  @HiveField(1)
  String primaryColor;

  @HiveField(2)
  Map<String, String> primaryColorSwatch;

  @HiveField(3)
  String secondaryColor;

  @HiveField(4)
  String logoUrl;

  @HiveField(5)
  String bannerUrl;

  @HiveField(6)
  String companyName;

  @HiveField(7)
  String apiVersion;

  @HiveField(8)
  String fontFamily;

  @HiveField(11)
  int version;

  OrganizationThemeConfig({
    required this.organizationId,
    required this.primaryColor,
    required this.primaryColorSwatch,
    required this.secondaryColor,
    required this.logoUrl,
    required this.bannerUrl,
    required this.companyName,
    required this.apiVersion,
    required this.fontFamily,
    this.version = 1,
  });

  // Create from base theme
  factory OrganizationThemeConfig.fromBaseTheme({
    required String organizationId,
  }) {
    return OrganizationThemeConfig(
      organizationId: organizationId,
      primaryColor: DefaultThemeConstants.primaryColor,
      primaryColorSwatch: DefaultThemeConstants.primaryColorSwatch,
      secondaryColor: DefaultThemeConstants.secondaryColor,
      logoUrl: DefaultThemeConstants.logoUrl,
      bannerUrl: DefaultThemeConstants.bannerUrl,
      companyName: DefaultThemeConstants.companyName,
      apiVersion: '1.0.0',
      fontFamily: DefaultThemeConstants.fontFamily,
    );
  }

  // Copy with method for updates
  OrganizationThemeConfig copyWith({
    String? organizationId,
    String? primaryColor,
    Map<String, String>? primaryColorSwatch,
    String? secondaryColor,
    String? logoUrl,
    String? bannerUrl,
    String? companyName,
    String? apiVersion,
    String? fontFamily,
    DateTime? lastUpdated,
  }) {
    return OrganizationThemeConfig(
      organizationId: organizationId ?? this.organizationId,
      primaryColor: primaryColor ?? this.primaryColor,
      primaryColorSwatch: primaryColorSwatch ?? this.primaryColorSwatch,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      companyName: companyName ?? this.companyName,
      apiVersion: apiVersion ?? this.apiVersion,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organizationId': organizationId,
      'primaryColor': primaryColor,
      'primaryColorSwatch': primaryColorSwatch,
      'secondaryColor': secondaryColor,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'companyName': companyName,
      'apiVersion': apiVersion,
      'fontFamily': fontFamily,
      'version': version,
    };
  }

  factory OrganizationThemeConfig.fromJson(Map<String, dynamic> jsonMap) {
    return OrganizationThemeConfig(
      organizationId:
          jsonMap['organizationId'] ??
          DefaultThemeConstants.marcomOrganizationId,
      primaryColor:
          jsonMap['primaryColor'] ?? DefaultThemeConstants.primaryColor,
      primaryColorSwatch: jsonMap['primaryColorSwatch'] == null
          ? DefaultThemeConstants.primaryColorSwatch
          : Map<String, String>.from(
              json.decode(jsonMap['primaryColorSwatch']),
            ),
      secondaryColor:
          jsonMap['secondaryColor'] ?? DefaultThemeConstants.secondaryColor,
      logoUrl: jsonMap['logoUrl'] ?? DefaultThemeConstants.logoUrl,
      bannerUrl: jsonMap['bannerUrl'] ?? DefaultThemeConstants.bannerUrl,
      companyName: jsonMap['companyName'] ?? DefaultThemeConstants.companyName,
      apiVersion: jsonMap['apiVersion'] ?? "/v2",
      fontFamily: jsonMap['fontFamily'] ?? DefaultThemeConstants.fontFamily,
    );
  }

  @override
  String toString() {
    return 'OrganizationThemeConfig('
        'organizationId: $organizationId, '
        'primaryColor: $primaryColor, '
        'primaryColorSwatch: $primaryColorSwatch, '
        'secondaryColor: $secondaryColor, '
        'logoUrl: $logoUrl, '
        'bannerUrl: $bannerUrl, '
        'companyName: $companyName, '
        'apiVersion: $apiVersion, '
        'fontFamily: $fontFamily'
        'version: $version'
        ')';
  }
}
