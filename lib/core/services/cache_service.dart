import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/text_constants.dart';
import '../utils/util_functions.dart';
import 'package:injectable/injectable.dart';

///used for all saved data to the phone
///FlutterSecureStorage stores session token, language, and in-app review tracking data
///so when user deletes the app we persist their language and review preferences
///other than that everything else is saved with SharedPreferences
@lazySingleton
class CacheService {
  const CacheService(this._storage, this._preferences);

  final FlutterSecureStorage _storage;
  final SharedPreferences _preferences;
  static const _sessionTokenKey = 'app-user-session-token';
  static const _firstTimerKey = 'app-is-user-first-timer';
  static const _language = 'app-language';
  static const _timeZoneKey = 'system-timezone';

  // In-app review tracking
  static const _reviewRequestCount = 'in-app-review-request-count';
  static const _lastReviewRequestDate = 'in-app-review-last-request-date';
  static const _reviewActivityCount = 'in-app-review-activity-count';

  Future<bool> setTimeZone(String url) async {
    try {
      final result = await _preferences.setString(_timeZoneKey, url);
      return result;
    } catch (_) {
      return false;
    }
  }

  Future<String> getTimeZone() async {
    final url =
        _preferences.getString(_timeZoneKey) ?? TextConstants.starterTimeZone;
    return url;
  }

  bool isFirstTime() {
    bool isFirstTime = _preferences.getBool(_firstTimerKey) ?? true;
    return isFirstTime;
  }

  Future<void> cacheFirstTimer() async {
    await _preferences.setBool(_firstTimerKey, false);
  }

  Future<void> logout() async {
    await Future.wait([
      _preferences.remove(_sessionTokenKey),
      _storage.delete(key: _sessionTokenKey),
    ]);
    UtilFunctions.appLog("Logout and removed locally saved session");
  }

  /// local storage
  Future<bool> setLanguage(String language) async {
    try {
      await _storage.write(key: _language, value: language);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// local storage
  Future<String?> getLanguage() async {
    final language = await _storage.read(key: _language);
    return language;
  }

  ///local storage for security
  Future<bool> cacheSessionToken(String token) async {
    try {
      await _storage.write(key: _sessionTokenKey, value: token);
      return true;
    } catch (_) {
      return false;
    }
  }

  ///local storage for security
  Future<String?> getSessionToken() async {
    final sessionToken = await _storage.read(key: _sessionTokenKey);
    return sessionToken;
  }

  // Session & Data Management
  Future<void> resetSession() async {
    await Future.wait([
      _preferences.remove(_firstTimerKey),
      _storage.delete(key: _sessionTokenKey),
      _storage.delete(key: _language),
    ]);
  }

  // Optional: Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // In-app review methods

  /// Get the number of review requests made
  Future<int> getReviewRequestCount() async {
    final value = await _storage.read(key: _reviewRequestCount);
    return value != null ? int.tryParse(value) ?? 0 : 0;
  }

  /// Set the number of review requests made
  Future<bool> setReviewRequestCount(int count) async {
    try {
      await _storage.write(key: _reviewRequestCount, value: count.toString());
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Get the last review request date (ISO 8601 string)
  Future<String?> getLastReviewRequestDate() async {
    return await _storage.read(key: _lastReviewRequestDate);
  }

  /// Set the last review request date (ISO 8601 string)
  Future<bool> setLastReviewRequestDate(String isoDate) async {
    try {
      await _storage.write(key: _lastReviewRequestDate, value: isoDate);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Get the count of the key action that earns a review prompt (e.g. orders
  /// placed). Bump it with [setReviewActivityCount] where that action succeeds.
  Future<int> getReviewActivityCount() async {
    final value = await _storage.read(key: _reviewActivityCount);
    return value != null ? int.tryParse(value) ?? 0 : 0;
  }

  /// Set the review activity count
  Future<bool> setReviewActivityCount(int count) async {
    try {
      await _storage.write(key: _reviewActivityCount, value: count.toString());
      return true;
    } catch (_) {
      return false;
    }
  }
}
