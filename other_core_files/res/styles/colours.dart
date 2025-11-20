import 'package:flutter/material.dart';

abstract class Colours {
  static const Color primaryColor = Color(0xFF587a6f);
  static const Color secondaryColor = Color(0xFFE67E22);
  static const scaffoldBackground = Color(0xFFfcfcfa);
  static const aiGradient = [
    Color(0xFFbad9e0),
    Color(0xFFddc2ed),
    Color(0xFFe0a6cd),
  ];

  // Primary Color Swatch
  static const MaterialColor primaryColorSwatch =
      MaterialColor(0xFF587a6f, <int, Color>{
        50: Color(0xFFe0e6e4),
        100: Color(0xFFb3c2bd),
        200: Color(0xFF809b94),
        300: Color(0xFF4d746b),
        400: Color(0xFF265b51),
        500: primaryColor,
        600: Color(0xFF507267),
        700: Color(0xFF46675c),
        800: Color(0xFF3d5d52),
        900: Color(0xFF2e4d40),
      });

  static Color borderGreyColor = Colors.black.withValues(alpha: 0.1);

  // Neutral Colors
  static const kWhite = Color(0xFFFFFFFF);
  static const kBlack = Color(0xFF030508);
  static const Color textBlackColor = Colors.black87;
  static const Color textHighlightColor = Color(0xFF515755);

  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey = Color(0xFFBDBDBD);
  static Color hintTextColor = Colors.black.withValues(alpha: 0.5);
  static Color lightGreyTextColor = Colors.grey[600]!;
  static const Color darkGrey = Color(0xFF757575);

  // final x= Colors.grey[400];

  // Status/Accent Colors
  static const Color lightGreen = Colors.green;
  static const Color onTimeGreen = Color(0xFF2E7D32);

  ///tooEarlyOrange also used in multiple place
  static const Color tooEarlyOrange = Colors.orange;
  static const Color lateRed = Color(0xFFF54135);

  static const Color approvedGreen = Color(0xFFE8F5E9);

  static const Color holidayOrWeekendColor = Colors.amber;
  static const Color sickDayColor = Colors.pinkAccent;

  static const Color notAvailableGrey = Colors.grey;

  // static const Color pendingYellow = Color(
  //   0xFFFFFACD,
  // ); // Light yellow for 'Pending' tag background
  // Light green for 'Approved' tag background
  static const Color rejectedRed = Color(0xFFFFEBEE);

  static const Color rejectedButtonRed = Colors.redAccent;
  static final Color approveButtonGreen = Color(
    0xFF2E7D32,
  ).withValues(alpha: 0.7);

  // Light red for 'Rejected' tag background
  // static const Color redDot = Color(0xFFD32F2F); // Red dot for calendar dates

  // Text Colors for Status Tags (assuming dark text on light backgrounds)
  // static const Color statusTagText = Color(0xFF333333);

  // Map Colors (approximate based on visual)
  // static const Color mapBackground = Color(
  //   0xFFE0E0E0,
  // ); // Light gray for map background
  static const Color mapRoads = Color(0xFFFFFFFF); // White for roads
  static const Color mapPin = Color(0xFF587a6f); // Primary color for map pin

  static const Color errorColor = Color(0xFFF54135);
  static const Color greenSuccess = Color(0xFF0D7C66);
  static const Color yellowWarningColor = Color(0xFFF2B325);
  static const Color onLeaveColor = Color(0xFF2196F3);

  static const Color homeAppBarColor = Color(0xFF1A1A1A);
  //
}
