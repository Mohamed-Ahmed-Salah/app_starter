import '../../src/auth/presentation/views/login_view.dart';
import '../constants/network_constants.dart';
import '../router.dart';
import '../utils/util_functions.dart';
import 'cache_service.dart';
import 'logout_service.dart';
import 'package:injectable/injectable.dart';

/// Service responsible for handling authentication-related events globally
/// Particularly handles 401 Unauthorized errors by automatically logging out
/// and navigating to the login screen
@lazySingleton
class AuthEventHandlerService {
  AuthEventHandlerService({
    required LogoutService logoutService,
    required CacheService cacheService,
  }) : _logoutService = logoutService,
       _cacheService = cacheService;

  final LogoutService _logoutService;
  final CacheService _cacheService;

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

    // A guest sent no token, so a 401 says nothing about their session — some
    // screens deliberately call authenticated endpoints while browsing as a
    // guest, and kicking them to login would break those flows.
    final sessionToken = await _cacheService.getSessionToken();
    if (sessionToken == null || sessionToken.isEmpty) {
      UtilFunctions.appLog('401 Error: No session to clear, ignoring...');
      return;
    }

    try {
      _isNavigating = true;
      _lastNavigationTime = now;

      UtilFunctions.appLog('401 Error: Handling unauthenticated error...');

      // Awaited so the token is gone before the login screen is built and
      // starts issuing its own calls.
      await _logoutService.logout();

      // go() rather than push(): the stack behind it holds authenticated
      // screens the user must not be able to go back to.
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
