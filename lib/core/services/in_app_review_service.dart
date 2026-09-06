import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

import '../constants/text_constants.dart';
import '../monitoring/firebase_error_logger_service.dart';
import '../utils/util_functions.dart';
import 'cache_service.dart';
import 'package:injectable/injectable.dart';

/// Service to show in-app rating prompt at key milestones
@lazySingleton
class InAppReviewService {
  const InAppReviewService({
    required InAppReview inAppReview,
    required CacheService cacheService,
  }) : _inAppReview = inAppReview,
       _cacheService = cacheService;

  final InAppReview _inAppReview;
  final CacheService _cacheService;

  /// Milestones of the tracked activity at which the 1st, 2nd and 3rd prompt
  /// are shown. Stores allow roughly three prompts a year, hence three.
  static const List<int> _milestones = [10, 20, 30];

  /// Request a review after a key action if a milestone has been reached.
  /// Call it right after the action succeeds and its activity count is bumped.
  Future<void> requestReviewIfDue() async {
    // Don't show on web
    if (kIsWeb) return;

    final activityCount = await _cacheService.getReviewActivityCount();

    if (await _canRequestReview()) {
      final requestCount = await _cacheService.getReviewRequestCount();

      final due =
          requestCount < _milestones.length &&
          activityCount >= _milestones[requestCount];

      if (due) {
        await _requestReview(activityCount);
      } else {
        UtilFunctions.appLog(
          'ℹ️ [InAppReviewService] not due - activityCount: $activityCount, requestCount: $requestCount',
        );
      }
    }
  }

  /// Core method to request review
  Future<void> _requestReview(int count) async {
    try {
      UtilFunctions.appLog('ℹ️ Requesting in-app review - count: $count');

      await _inAppReview.requestReview();

      // Increment request count
      final currentCount = await _cacheService.getReviewRequestCount();
      await _cacheService.setReviewRequestCount(currentCount + 1);

      // Update last request date
      await _cacheService.setLastReviewRequestDate(
        DateTime.now().toIso8601String(),
      );

      UtilFunctions.appLog('✅ In-app review requested successfully');
    } catch (e, stackTrace) {
      UtilFunctions.appLog('❌ [DEBUG] Failed to request review: $e');
      FirebaseErrorLoggerService.to.logError(e, stackTrace);
    }
  }

  /// Check if we can request a review
  Future<bool> _canRequestReview() async {
    // Check if in-app review is available on this platform
    if (!await _inAppReview.isAvailable()) {
      return false;
    }

    // Check if we've hit the yearly limit
    final requestCount = await _cacheService.getReviewRequestCount();
    final lastRequestDate = await _cacheService.getLastReviewRequestDate();

    // If we have a last request date
    if (lastRequestDate != null) {
      final lastDate = DateTime.parse(lastRequestDate);
      final daysSince = DateTime.now().difference(lastDate).inDays;

      // Reset counter if more than 365 days
      if (daysSince >= 365) {
        await _cacheService.setReviewRequestCount(0);
        return true;
      }

      // Check if we've exceeded limit within the year
      if (requestCount >= _milestones.length) {
        UtilFunctions.appLog('ℹ️ Review request limit reached for this year');
        return false;
      }
    }

    return true;
  }

  /// Reset metadata (for testing only)
  Future<void> resetForTesting() async {
    await _cacheService.setReviewRequestCount(0);
    await _cacheService.setLastReviewRequestDate(
      DateTime.now().toIso8601String(),
    );
    UtilFunctions.appLog('✅ Review metadata reset for testing');
  }

  Future<void> manualReview() async {
    _inAppReview.openStoreListing(appStoreId: TextConstants.iosAppId);
  }
}
