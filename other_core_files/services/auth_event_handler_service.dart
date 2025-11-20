import 'package:attendance/core/constants/network_constants.dart';
import 'package:attendance/core/services/cache_service.dart';
import 'package:attendance/core/services/router.dart';
import 'package:attendance/core/utils/util_functions.dart';
import 'package:attendance/src/auth/presentation/view/login_view.dart';

/// Service responsible for handling authentication-related events globally
/// Particularly handles 401 Unauthorized errors by automatically logging out
/// and navigating to the login screen
class AuthEventHandlerService {
  AuthEventHandlerService({required CacheService cacheService})
    : _cacheService = cacheService;

  final CacheService _cacheService;

  // Singleton access (fallback for places that can't use DI)
  static late AuthEventHandlerService instance;

  // Debouncing state

  DateTime? _lastNavigationTime;
  static const _navigationDebounceWindow = Duration(
    seconds: NetworkConstants.timeout,
  );
  bool _isNavigating = false;

  /// Handle 401 error - called from NetworkCallHandler
  /// This method ensures that even when multiple concurrent API calls
  /// all return 401, the navigation to login happens only once
  Future<void> handle401Error() async {
    // Prevent concurrent executions
    if (_isNavigating) {
      UtilFunctions.appLog(
        '401 Error: Already navigating to login, ignoring...',
      );
      return;
    }

    // Check debounce window
    final now = DateTime.now();
    if (_lastNavigationTime != null) {
      final timeSinceLastNav = now.difference(_lastNavigationTime!);
      if (timeSinceLastNav < _navigationDebounceWindow) {
        UtilFunctions.appLog(
          '401 Error: Within debounce window (${timeSinceLastNav.inMilliseconds}ms), ignoring...',
        );
        return;
      }
    }

    try {
      _isNavigating = true;
      _lastNavigationTime = now;

      UtilFunctions.appLog('401 Error: Handling unauthenticated error...');

      // Step 1: Clear user session
      await _cacheService.logout();
      UtilFunctions.appLog('401 Error: Session cleared');

      // Step 2: Navigate to login
      // Use go() instead of push() to clear navigation stack
      // This prevents users from navigating back to authenticated screens
      router.go(LoginView.path);
      UtilFunctions.appLog('401 Error: Navigated to login screen');
    } catch (e, stackTrace) {
      UtilFunctions.appLog('Error handling 401: $e');
      UtilFunctions.appLog('StackTrace: $stackTrace');
      // Still reset flag to allow retry
    } finally {
      // Reset navigation flag after a delay
      // the delay is used here with _navigationDebounceWindow (NetworkConstants.timeout)
      // so we're safe even when response came within connection timeout
      Future.delayed(_navigationDebounceWindow, () {
        _isNavigating = false;
      });
    }
  }

  /// Reset the handler state (useful for testing)
  void reset() {
    _isNavigating = false;
    _lastNavigationTime = null;
  }
}
