import 'dart:io';

import 'package:attendance/core/constants/size_constants.dart';
import 'package:attendance/core/constants/text_constants.dart';
import 'package:attendance/core/res/media.dart';
import 'package:attendance/core/res/styles/colours.dart';
import 'package:attendance/core/services/notification_service.dart';
import 'package:attendance/core/widgets/approval_rejection_bottom_sheet.dart';
import 'package:attendance/core/widgets/confirmation_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../config/enums.dart';

abstract class UtilFunctions {
  static void showSnackBar({
    BuildContext? context,
    required String message,
    Color backgroundColor = Colours.errorColor,
    int timeInSec = 5,
    IconData? icon,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: timeInSec,
      backgroundColor: backgroundColor,
      textColor: Colours.kWhite,
    );
    // scaffoldKey.currentState?.showSnackBar(
    //   SnackBar(
    //     content: Row(
    //       children: [
    //         if (icon != null) ...[
    //           Icon(icon, color: Colours.kWhite),
    //           const SizedBox(width: 8),
    //         ],
    //         Expanded(child: Text(message)),
    //       ],
    //     ),
    //     backgroundColor: backgroundColor,
    //     duration: duration,
    //     behavior: SnackBarBehavior.floating,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //   ),
    // );
  }

  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // Prevent dismissing with back button
          child: Center(
            child: Container(
              // width: 100,
              // height: 100,
              decoration: BoxDecoration(
                color: Colours.kWhite,
                borderRadius: BorderRadius.circular(
                  SizeConstants.fullBorderRadius,
                ),
              ),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }

  static void appLog(String message) {
    if (!kReleaseMode) {
      // prints only in debug or profile
      debugPrintThrottled(message);
    }
  }

  /// Request Location Permission
  static Future<bool> requestLocationPermission() async {
    debugPrintThrottled("Starting permission request...");
    var status = await Permission.location.request();
    debugPrintThrottled("First permission result: $status");

    if (status.isGranted) {
      return status.isGranted;
    } else if (status.isPermanentlyDenied || status.isDenied) {
      debugPrintThrottled("First permission denied, returning false");
      return false;
    }
    debugPrintThrottled("Unexpected case, returning false");
    return false;
  }

  ///This does not await the users response.
  ///theres an open issue explained: https://github.com/Baseflow/flutter-permission-handler/issues/1152
  static Future<PermissionStatus>
  requestLocationAlwaysInBackgroundPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      debugPrintThrottled("Starting alwaysStatus permission request...");
      var locationStatus = await Permission.locationAlways.request();

      return locationStatus;
    }
    return status;
  }

  /// Request Camera Permission
  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied || status.isDenied) {
      return false;
    }
    return false;
  }

  /// Request Notification Permission
  static Future<bool> requestNotificationPermission() async {
    var status = await Permission.notification.request();
    if (status.isGranted) {
      if (Platform.isIOS) {
        await NotificationService.to.flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      }
      return true;
    } else if (status.isPermanentlyDenied || status.isDenied) {
      return false;
    }
    return false;
  }

  static void allowPermissionAccessSnackBar(
    BuildContext context,
    PermissionType type,
  ) {
    String title;
    String subtitle;
    final text = AppLocalizations.of(context);
    switch (type) {
      case PermissionType.camera:
        title = text!.camera_permission_title;
        subtitle = text.camera_permission_message;
        break;
      case PermissionType.location:
        title = text!.location_permission_title;
        subtitle = text.location_permission_message;
        break;
      case PermissionType.notification:
        title = text!.notification_permission_title;
        subtitle = text.notification_permission_message;
        break;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(subtitle),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Close dialog
                    await openAppSettings(); // Open app settings
                  },
                  child: Text(
                    AppLocalizations.of(context)!.open_settings,
                    style: TextStyle(color: Colours.kWhite),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String subtitle,
    // required IconData icon,
    required VoidCallback onConfirm,
    String? confirmText,
    String? cancelText,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConfirmationDialogWidget(
            title: title,
            subtitle: subtitle,
            onConfirm: onConfirm,
            confirmText: confirmText,
            cancelText: cancelText,
          ),
        );
      },
    );
  }

  static String activityType(
    AppLocalizations? text,
    AttendanceActivityType type,
  ) {
    switch (type) {
      case AttendanceActivityType.checkIn:
        return "${text?.checkIn}";
      case AttendanceActivityType.checkOut:
        return "${text?.checkOut}";
      case AttendanceActivityType.takeBreak:
        return "${text?.breakTitle}";
    }
  }

  static IconData activityTypeIcon(AttendanceActivityType type) {
    switch (type) {
      case AttendanceActivityType.checkIn:
        return Media.checkInIcon;
      case AttendanceActivityType.checkOut:
        return Media.checkOutIcon;
      case AttendanceActivityType.takeBreak:
        return Media.breakIcon;
    }
  }

  static String activityTimeTypeText(
    AppLocalizations? text,
    AttendanceTimeType type,
  ) {
    switch (type) {
      case AttendanceTimeType.early:
        return "${text?.tooEarly}";
      case AttendanceTimeType.late:
        return "${text?.late}";
      case AttendanceTimeType.onTime:
        return "${text?.onTime}";
      case AttendanceTimeType.na:
        return "${text?.na}";
    }
  }

  static Color activityTimeTypeColor(AttendanceTimeType type) {
    switch (type) {
      case AttendanceTimeType.early:
        return Colours.tooEarlyOrange;
      case AttendanceTimeType.late:
        return Colours.lateRed;
      case AttendanceTimeType.onTime:
        return Colours.onTimeGreen;
      case AttendanceTimeType.na:
        return Colours.notAvailableGrey;
    }
  }

  static String tooEarlyOrTooLate(
    DateTime supposedTime,
    DateTime actualTime,
    AppLocalizations? text,
  ) {
    final difference = actualTime.difference(supposedTime);
    if (difference.isNegative) {
      final Duration earlyBy = difference.abs();
      return "${text?.minEarly(earlyBy.inMinutes)}";
    } else if (difference.inSeconds > 0) {
      return "${text?.minLate(difference.inMinutes)}";
    } else {
      return "";
    }
  }

  /// 🔹 Get background color based on type
  static Color getBackground(AttendanceDayType type) {
    return getBaseColor(type).withValues(alpha: 0.2);
  }

  /// 🔹 Get icon based on type
  static IconData? getIcon(AttendanceDayType type) {
    switch (type) {
      case AttendanceDayType.sick:
        return Media.heartPulseIcon;
      case AttendanceDayType.holiday:
        return Media.sunIcon;
      case AttendanceDayType.weekend:
        return null;
      case AttendanceDayType.attended:
        return Media.checkIcon;
      case AttendanceDayType.payedLeave:
        return Icons.beach_access;
      case AttendanceDayType.missed:
        return Media.closeIcon;
      default:
        return null;
    }
  }

  // Darker for icons/text
  static Color getForegroundColor(AttendanceDayType type) {
    return getBaseColor(type);
  }

  static Color getBaseColor(AttendanceDayType type) {
    switch (type) {
      case AttendanceDayType.sick:
        return Colours.sickDayColor;
      case AttendanceDayType.holiday:
        return Colours.holidayOrWeekendColor;
      case AttendanceDayType.weekend:
        return Colours.grey;
      case AttendanceDayType.attended:
        return Colours.greenSuccess;
      case AttendanceDayType.payedLeave:
        return Colours.onLeaveColor;
      case AttendanceDayType.missed:
        return Colours.errorColor;
      default:
        return Colours.grey;
    }
  }

  ///
  static Color getDashBorderColor(AttendanceDayType type) {
    switch (type) {
      case AttendanceDayType.sick:
        return Colours.sickDayColor;
      case AttendanceDayType.holiday:
        return Colors.transparent;
      case AttendanceDayType.weekend:
        return Colors.transparent;
      case AttendanceDayType.attended:
        return Colors.transparent;
      case AttendanceDayType.payedLeave:
        return Colours.onLeaveColor;
      case AttendanceDayType.missed:
        return Colours.errorColor;
      default:
        return Colors.transparent;
    }
  }

  static Color getAttendanceTypeStatusColor(AttendanceType type) {
    switch (type) {
      case AttendanceType.present:
        return Colours.onTimeGreen;
      case AttendanceType.absent:
        return Colours.lateRed;
      case AttendanceType.onVacation:
        return Colours.onLeaveColor;
    }
  }

  static void openPrivacyUrl() async {
    final Uri url = Uri.parse(
      TextConstants.privacyUrl,
    ); // Replace with your URL
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  static void showRequestApprovalRejectionBottomSheet(
    BuildContext context, {
    required int id,
    required RequestStatus status,
    required String title,
    required String subtitle,
    required Function(int, String) onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SizeConstants.outerBorderRadius),
        ),
      ),
      builder: (bottomSheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          left: SizeConstants.baseHorizontalPadding.w,
          right: SizeConstants.baseHorizontalPadding.w,
          top: 16,
        ),
        child: ApprovalRejectionBottomSheet(
          status: status,
          title: title,
          subtitle: subtitle,
          id: id,
          onConfirm: onConfirm,
        ),
      ),
    );
  }

  static String paymentTypeLocalizedText(
    BuildContext context,
    PaymentType type,
  ) {
    final text = AppLocalizations.of(context);
    switch (type) {
      case PaymentType.continues:
        return text?.paymentTypeContinues ?? 'Continues Payment';
      case PaymentType.advanced:
        return text?.paymentTypeAdvanced ?? 'Advanced Payment';
    }
  }

  static String emergencyContactMediumLocalizedText(
    BuildContext context,
    EmergencyContactMedium medium,
  ) {
    final text = AppLocalizations.of(context);

    switch (medium) {
      case EmergencyContactMedium.phone:
        return '${text?.emergencyContactPhone}';
      case EmergencyContactMedium.email:
        return '${text?.emergencyContactEmail}';
      case EmergencyContactMedium.whatsapp:
        return '${text?.emergencyContactWhatsApp}';
    }
  }
}
