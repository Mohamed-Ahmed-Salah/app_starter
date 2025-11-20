import 'dart:io';

import 'package:attendance/core/utils/util_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Helper class for getting unique device identifiers
/// Used for login and check-in authentication
class DeviceIdentifierHelper {
  /// Get unique device identifier for current platform
  /// Returns Android ID for Android, identifierForVendor for iOS
  static Future<String> getDeviceIdentifier() async {
    try {
      UtilFunctions.appLog("DeviceIdentifierHelper: Getting device identifier");

      if (Platform.isAndroid) {
        return await _getAndroidId();
      } else if (Platform.isIOS) {
        return await _getIOSId();
      } else {
        UtilFunctions.appLog(
          "DeviceIdentifierHelper: Unsupported platform",
        );
        return 'Unsupported platform';
      }
    } catch (e) {
      UtilFunctions.appLog("DeviceIdentifierHelper error: $e");
      return 'Error: $e';
    }
  }

  /// Get Android device ID using device_info_plus
  /// Returns Android ID (most stable identifier)
  static Future<String> _getAndroidId() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final deviceId = androidInfo.id;

    UtilFunctions.appLog("DeviceIdentifierHelper: Android ID = $deviceId");
    return deviceId; // Android ID
  }

  /// Get iOS device ID using device_info_plus
  /// Returns identifierForVendor (unique per app vendor)
  /// This changes if user uninstalls all apps from the same vendor
  static Future<String> _getIOSId() async {
    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    final deviceId = iosInfo.identifierForVendor ?? 'Unknown';

    UtilFunctions.appLog("DeviceIdentifierHelper: iOS ID = $deviceId");
    return deviceId;
  }
}
