import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_starter/core/constants/text_constants.dart';
import 'package:app_starter/core/monitoring/firebase_error_logger_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '/core/res/colours.dart';
import 'package:toastification/toastification.dart';

import '../res/media.dart';

abstract class UtilFunctions {
  static void appLog(String message) {
    if (!kReleaseMode) {
      debugPrint(message);
    }
  }

  static void showSuccessToast({
    BuildContext? context,
    required String message,
    int duration = 3,
    AlignmentGeometry? alignment,
  }) {
    _showToast(
      context: context,
      message: message,
      duration: duration,
      alignment: alignment,
      type: ToastificationType.success,
      icon: Media.successToastIcon,
      iconColor: Colours.success,
    );
  }

  /// The failure counterpart of [showSuccessToast]. Use it for problems the
  /// user can fix and retry on the spot (an oversized upload, say) —
  /// [showFailedToast] stays the channel for request failures.
  static void showErrorToast({
    BuildContext? context,
    required String message,
    int duration = 3,
    AlignmentGeometry? alignment,
  }) {
    _showToast(
      context: context,
      message: message,
      duration: duration,
      alignment: alignment,
      type: ToastificationType.warning,
      icon: Media.warningToastIcon,
      iconColor: Colours.error,
    );
  }

  // No `context` is needed: with `context` null the toast renders into the
  // global overlay created by [ToastificationWrapper] (mounted at the root in
  // main.dart), so it paints on top of any nav bar across every screen.
  static void _showToast({
    required BuildContext? context,
    required String message,
    required int duration,
    required AlignmentGeometry? alignment,
    required ToastificationType type,
    required IconData icon,
    required Color iconColor,
  }) {
    toastification.show(
      context: context,
      alignment: alignment ?? const Alignment(0.0, 0.85),
      autoCloseDuration: Duration(seconds: duration),
      animationDuration: const Duration(milliseconds: 300),
      type: type,
      style: .minimal,
      icon: Icon(icon, color: iconColor),
      description: Text(message),
    );
  }

  static void showFailedToast({
    BuildContext? context,
    required String message,
    int duration = 3,
    IconData icon = Media.xMarkIcon,
    Color color = Colours.errorColor,
  }) {
    toastification.show(
      alignment: Alignment.topCenter,
      context: context,
      description: Text(message),
      type: ToastificationType.error,
      style: .minimal,
      icon: Icon(icon, color: color),
      autoCloseDuration: Duration(seconds: duration),
    );
  }

  /// Opens an arbitrary link outside the app, in the browser or whichever
  /// handler the platform picks for it.
  static void openExternalUrl(String rawUrl) async {
    try {
      final Uri url = Uri.parse(rawUrl);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {}
    } catch (e, stackTrace) {
      FirebaseErrorLoggerService.to.logError(e, stackTrace);
    }
  }

  static void openPrivacyUrl() => openExternalUrl(TextConstants.privacyUrl);

  static void openTermsUrl() => openExternalUrl(TextConstants.termsUrl);

  static void openAboutUrl() => openExternalUrl(TextConstants.aboutUrl);

  static void openFaqUrl() => openExternalUrl(TextConstants.faqsUrl);

  static void openSupportUrl() =>
      openExternalUrl(TextConstants.contactSupportUrl);

  /// Lightweight stand-in for pages that aren't built yet: surfaces a short
  /// "coming soon" message so placeholder rows still give the user feedback.
  static void showComingSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Soft tinted surface for an initials profile circle. Rotates through a
  /// 3-colour palette by [index] so adjacent avatars in a list differ. All
  /// three are light enough to carry [Colours.warmBlack] initials.
  static const List<Color> _avatarBackgrounds = [
    Colours.mint100,
    Colours.cream200,
    Colours.blush100,
  ];

  static Color avatarBackgroundColor(int index) =>
      _avatarBackgrounds[index % _avatarBackgrounds.length];

  /// Up-to-two-letter initials from a display [name] — the first letters of the
  /// first two words, e.g. "Omar Leg" → "OL". Returns "?" when [name] is blank.
  static String avatarInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    if (words.isEmpty) return '?';
    return words.take(2).map((w) => w[0]).join().toUpperCase();
  }
}
