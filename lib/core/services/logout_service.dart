import '../monitoring/firebase_error_logger_service.dart';
import '../utils/util_functions.dart';
import 'cache_service.dart';
import 'notification_service.dart';
import 'package:injectable/injectable.dart';

/// Single place that tears a session down: cancel notifications, clear the
/// cached token. Extend it (sign out of Firebase Auth, reset a user-status
/// cubit, …) rather than scattering logout steps across cubits.
@lazySingleton
class LogoutService {
  LogoutService({required CacheService cacheService})
    : _cacheService = cacheService;

  final CacheService _cacheService;

  Future<void> logout() async {
    try {
      UtilFunctions.appLog('🚪 Starting logout process...');

      UtilFunctions.appLog('🔔 Cancelling all notifications...');
      NotificationService.to.cancelAllNotifications();

      UtilFunctions.appLog('🗑️  Clearing session data...');
      await _cacheService.logout();

      UtilFunctions.appLog('✅ Logout completed successfully');
    } catch (e, stackTrace) {
      UtilFunctions.appLog('❌ Error during logout: $e');
      UtilFunctions.appLog('StackTrace: $stackTrace');
      FirebaseErrorLoggerService.to.logError(e, stackTrace);
    }
  }
}
