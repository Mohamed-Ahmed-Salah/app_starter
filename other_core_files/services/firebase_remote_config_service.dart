import 'package:attendance/core/constants/default_theme_firebase_constants.dart';
import 'package:attendance/core/services/cache_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:attendance/core/utils/util_functions.dart';

import '../config/organization_theme_config.dart' show OrganizationThemeConfig;
import '../constants/network_constants.dart';
import 'hive_data_service.dart';
import 'injection_container.dart';

class FirebaseRemoteConfigService {
  ///variable to check if is success recieved new and update config on each app start
  static bool successConfig = false;

  /// Remote Config Keys
  static const String _primaryColorKey = 'primary_color';
  static const String _primaryColorSwatchKey = 'primary_color_swatch';
  static const String _secondaryColorKey = 'secondary_color';
  static const String _logoUrlKey = 'logo_url';

  static const String _companyNameKey = 'company_name';
  static const String _organizationIdKey = 'organization_id';
  static const String _apiVersionKey = 'api_version';
  static const String _fontFamilyKey = 'font_family';
  static const String _iosMinVersion = 'iosMinVersion';
  static const String _androidMinVersion = 'androidMinVersion';
  static bool _successRemoteConfigFetchStatus = false;

  ///default if failed
  final Map<String, dynamic> _defaults = {
    _organizationIdKey: DefaultThemeConstants.marcomOrganizationId,
    // Colors
    _primaryColorKey: DefaultThemeConstants.primaryColor,

    _primaryColorSwatchKey: '${DefaultThemeConstants.primaryColorSwatch}',
    _secondaryColorKey: DefaultThemeConstants.secondaryColor,
    // Images
    _logoUrlKey: DefaultThemeConstants.logoUrl,

    _companyNameKey: DefaultThemeConstants.companyName,
    _apiVersionKey: '/v1',

    // Typography
    _fontFamilyKey: DefaultThemeConstants.fontFamily,
  };
  String? _currentOrganizationId;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize({String? organizationId}) async {
    // Initialize Hive box
    final HiveDataService hiveDataService = sl<HiveDataService>();
    final CacheService cacheService = sl<CacheService>();

    try {
      _currentOrganizationId =
          organizationId ?? DefaultThemeConstants.marcomOrganizationId;

      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: NetworkConstants.timeout),
          minimumFetchInterval: Duration.zero, // Production: longer interval
        ),
      );

      // Set default values
      await _remoteConfig.setDefaults(_defaults);

      // Try to fetch from Remote Config
      _successRemoteConfigFetchStatus = await _fetchAndActivate();
      successConfig = _successRemoteConfigFetchStatus;

      UtilFunctions.appLog(
        '✅ Remote Config initialized for organization: $_currentOrganizationId',
      );
    } catch (e) {
      UtilFunctions.appLog('❌ Failed to initialize Remote Config: $e');
      // Load from Hive or use base theme
    } finally {
      final newTheme = getAllConfiguration();

      if (_successRemoteConfigFetchStatus && newTheme != null) {
        /// After each time we receive configuration we will save organization id and configuration...
        ///
        UtilFunctions.appLog(
          'CALLING hiveDataService.saveThemeConfig(newTheme);',
        );
        await cacheService.setOrganizationId(newTheme.organizationId);
        await hiveDataService.saveThemeConfig(newTheme);
      }
    }
  }

  Future<bool> _fetchAndActivate() async {
    try {
      // Set the user property for analytics (used by Remote Config conditions)
      await FirebaseAnalytics.instance.setUserProperty(
        name: _organizationIdKey,
        value: _currentOrganizationId,
      );

      bool updated = await _remoteConfig.fetchAndActivate();
      if (updated) {
        UtilFunctions.appLog('🔄 Remote Config values updated');
      } else {
        UtilFunctions.appLog('ℹ️ Remote Config values not updated');
      }
      return true;
    } catch (e) {
      UtilFunctions.appLog('❌ Failed to fetch and activate remote config: $e');
      return false;
    }
  }

  // Getters for configuration values
  String getPrimaryColor() {
    try {
      return _remoteConfig.getString(_primaryColorKey);
    } catch (e) {
      UtilFunctions.appLog('❌ Failed to get primary color, using default: $e');
      return _defaults[_primaryColorKey];
    }
  }

  String getPrimaryColorSwatch() {
    try {
      final swatchString = _remoteConfig.getString(_primaryColorSwatchKey);
      return swatchString;
    } catch (e) {
      UtilFunctions.appLog(
        '❌ Failed to get primary color swatch, using default: $e',
      );
      return _defaults[_primaryColorSwatchKey];
    }
  }

  String getSecondaryColor() {
    try {
      return _remoteConfig.getString(_secondaryColorKey);
    } catch (e) {
      UtilFunctions.appLog(
        '❌ Failed to get secondary color, using default: $e',
      );
      return _defaults[_secondaryColorKey];
    }
  }

  String getOrganizationId() {
    try {
      return _remoteConfig.getString(_organizationIdKey);
    } catch (e) {
      UtilFunctions.appLog(
        '❌ Failed to get _organizationIdKey, using default: $e',
      );
      return _defaults[_organizationIdKey];
    }
  }

  String getLogoUrl() {
    try {
      return _remoteConfig.getString(_logoUrlKey);
    } catch (e) {
      UtilFunctions.appLog('❌ Failed to get logo URL, using default: $e');
      return _defaults[_logoUrlKey];
    }
  }

  String getCompanyName() {
    try {
      return _remoteConfig.getString(_companyNameKey);
    } catch (e) {
      UtilFunctions.appLog('❌ Failed to get company name, using default: $e');
      return _defaults[_companyNameKey];
    }
  }

  String getApiVersion() {
    try {
      return _remoteConfig.getString(_apiVersionKey);
    } catch (e) {
      UtilFunctions.appLog('❌ Failed to get API version, using default: $e');
      return _defaults[_apiVersionKey];
    }
  }

  String getFontFamily() {
    try {
      return _remoteConfig.getString(_fontFamilyKey);
    } catch (e) {
      UtilFunctions.appLog('❌ Failed to get font family, using default: $e');
      return _defaults[_fontFamilyKey];
    }
  }

  String? getIosMinVersion() {
    try {
      if (successConfig) {
        return _remoteConfig.getString(_iosMinVersion);
      } else {
        return null;
      }
    } catch (e) {
      UtilFunctions.appLog('❌ Failed to get _iosMinVersion, using default: $e');
      return _defaults[_iosMinVersion];
    }
  }

  String? getAndroidMinVersion() {
    try {
      if (successConfig) {
        return _remoteConfig.getString(_androidMinVersion);
      } else {
        return null;
      }
    } catch (e) {
      UtilFunctions.appLog(
        '❌ Failed to get _androidMinVersion, using default: $e',
      );
      return _defaults[_androidMinVersion];
    }
  }

  // Get all configuration as a map
  OrganizationThemeConfig? getAllConfiguration() {
    return _successRemoteConfigFetchStatus
        ? OrganizationThemeConfig.fromJson({
            'organizationId': getOrganizationId(),
            'primaryColor': getPrimaryColor(),
            'primaryColorSwatch': getPrimaryColorSwatch(),
            'secondaryColor': getSecondaryColor(),
            'logoUrl': getLogoUrl(),
            'companyName': getCompanyName(),
            'apiVersion': getApiVersion(),
            'fontFamily': getFontFamily(),
            'iosMinVersion': getIosMinVersion(),
            'androidMinVersion': getAndroidMinVersion(),
          })
        : null;
  }
}
