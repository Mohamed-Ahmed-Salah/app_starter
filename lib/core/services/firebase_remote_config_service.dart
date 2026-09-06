import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:app_starter/core/monitoring/firebase_error_logger_service.dart';
import '../constants/network_constants.dart';
import '../constants/text_constants.dart';
import '../utils/util_functions.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseRemoteConfigService {
  /// Remote Config Keys
  static const String _iosMinVersion = 'iosMinVersion';
  static const String _androidMinVersion = 'androidMinVersion';
  static const String _androidUpdateUrl = 'android_update_url';
  static const String _iosUpdateUrl = 'ios_update_url';
  static const String _contactUrl = 'support_url';

  ///default if failed
  final Map<String, dynamic> _defaults = {
    _androidUpdateUrl: TextConstants.androidUrl,
    _iosUpdateUrl: TextConstants.iosUrl,
    _contactUrl: TextConstants.contactSupportUrl,
    _iosMinVersion: "1.0.0",
    _androidMinVersion: "1.0.0",
  };
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: NetworkConstants.timeout),
          minimumFetchInterval: Duration.zero, // Production: longer interval
        ),
      );

      // Set default values
      await _remoteConfig.setDefaults(_defaults);

      await _fetchAndActivate();
      UtilFunctions.appLog('✅ Remote Config initialized');
    } catch (e, s) {
      UtilFunctions.appLog('❌ Failed to initialize Remote Config: $e');
      FirebaseErrorLoggerService.to.logError(e, s);
    }
  }

  Future<bool> _fetchAndActivate() async {
    try {
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

  String? getIosMinVersion() {
    try {
      return _remoteConfig.getString(_iosMinVersion);
    } catch (e) {
      UtilFunctions.appLog('❌ Failed to get _iosMinVersion, using default: $e');
      return _defaults[_iosMinVersion];
    }
  }

  String? getAndroidMinVersion() {
    try {
      return _remoteConfig.getString(_androidMinVersion);
    } catch (e) {
      UtilFunctions.appLog(
        '❌ Failed to get _androidMinVersion, using default: $e',
      );
      return _defaults[_androidMinVersion];
    }
  }

  String? getAndroidUpdateUrl() {
    try {
      return _remoteConfig.getString(_androidUpdateUrl);
    } catch (e) {
      UtilFunctions.appLog(
        '❌ Failed to get _androidUpdateUrl, using default: $e',
      );
      return _defaults[_androidUpdateUrl];
    }
  }

  String? getIosUpdateUrl() {
    try {
      return _remoteConfig.getString(_iosUpdateUrl);
    } catch (e) {
      UtilFunctions.appLog('❌ Failed to get _iosUpdateUrl, using default: $e');
      return _defaults[_iosUpdateUrl];
    }
  }

  String getContactUrl() {
    try {
      return _remoteConfig.getString(_contactUrl);
    } catch (e) {
      return _defaults[_contactUrl] as String;
    }
  }
}
