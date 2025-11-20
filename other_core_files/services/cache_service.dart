import 'package:attendance/core/constants/default_theme_firebase_constants.dart';
import 'package:attendance/core/constants/text_constants.dart';
import 'package:attendance/core/utils/util_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

///used for small single value data
class CacheService {
  const CacheService(this._prefs);

  final SharedPreferences _prefs;
  static const _sessionTokenKey = 'attendance-app-user-session-token';
  static const _firstTimerKey = 'attendance-app-is-user-first-timer';
  static const _language = 'attendance-app-language';
  static const _organizationId = 'attendance-app-organization-id';
  static const _userRoleIsUser = 'attendance-app-userRole';
  static const _authWithBio = 'attendance-app-auth-withBio';

  Future<bool> setLanguage(String language) async {
    try {
      final result = await _prefs.setString(_language, language);
      return result;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setUserRoleIsUser({required bool isNormalUser}) async {
    try {
      final result = await _prefs.setBool(_userRoleIsUser, isNormalUser);
      return result;
    } catch (_) {
      return false;
    }
  }

  Future<bool> getIsUserRoleNormalUser() async {
    final auth = _prefs.getBool(_userRoleIsUser);
    return auth ?? true;
  }

  Future<bool> setAuthWithBio(bool auth) async {
    try {
      final result = await _prefs.setBool(_authWithBio, auth);
      return result;
    } catch (_) {
      return false;
    }
  }

  Future<bool?> getAuthWithBio() async {
    final auth = _prefs.getBool(_authWithBio);
    return auth;
  }

  Future<String> getLanguage() async {
    final language = await _prefs.getString(_language);
    return language ?? TextConstants.starterLangCode;
  }

  Future<bool> setOrganizationId(String organizationId) async {
    try {
      final result = await _prefs.setString(_organizationId, organizationId);
      return result;
    } catch (_) {
      return false;
    }
  }

  Future<String> getOrganizationId() async {
    final organizationId = _prefs.getString(_organizationId);
    return organizationId ?? DefaultThemeConstants.marcomOrganizationId;
  }

  bool isFirstTime() {
    bool isFirstTime = _prefs.getBool(_firstTimerKey) ?? true;
    return isFirstTime;
  }

  Future<void> cacheFirstTimer() async {
    await _prefs.setBool(_firstTimerKey, false);
  }

  Future<bool> cacheSessionToken(String token) async {
    try {
      final result = await _prefs.setString(_sessionTokenKey, token);
      return result;
    } catch (_) {
      return false;
    }
  }

  Future<String?> getSessionToken() async {
    final sessionToken = _prefs.getString(_sessionTokenKey);

    return sessionToken;
  }

  Future<void> resetSession() async {
    await _prefs.remove(_sessionTokenKey);
    await _prefs.remove(_firstTimerKey);
    await _prefs.remove(_language);
    await _prefs.remove(_organizationId);
  }

  Future<void> logout() async {
    await _prefs.remove(_sessionTokenKey);
    await _prefs.remove(_organizationId);
    UtilFunctions.appLog(
      "Logout and removed locally saved session & _organization id",
    );
  }
}
