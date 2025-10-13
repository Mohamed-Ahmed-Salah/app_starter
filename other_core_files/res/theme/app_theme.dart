// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
//
// import '../styles/colours.dart';
//
// abstract class CustomTheme {
//   static AppBarTheme appBarLightTheme = const AppBarTheme(
//     // backgroundColor: Colours.kLightBorderColor,
//     elevation: 4,
//     iconTheme: IconThemeData(color: Colours.textBlackColor),
//     titleTextStyle: TextStyle(
//       fontSize: 18,
//       fontWeight: FontWeight.w600,
//       color: Colours.textBlackColor,
//     ),
//   );
//   static ElevatedButtonThemeData elevatedButtonThemeData =
//       ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colours.primaryColor,
//       disabledBackgroundColor: Colours.primaryColor,
//       disabledForegroundColor: Colours.kBlack,
//       foregroundColor: Colours.kBlack,
//       minimumSize: Size(0, 6.h),
//       textStyle: TextStyle(
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w500,
//           color: Colours.kWhite),
//       shape: RoundedRectangleBorder(
//         borderRadius:
//             BorderRadius.all(Radius.circular(20)),
//       ),
//     ),
//   );
//
//   static ThemeData lightTheme() {
//     return ThemeData(
//       brightness: Brightness.light,
//       progressIndicatorTheme: ProgressIndicatorThemeData(
//         color: Colours.primaryColor, // Your desired color
//         linearTrackColor: Colours.primaryColor.withValues(alpha:0.4), // For LinearProgressIndicator track
//         circularTrackColor: Colours.primaryColor.withValues(alpha:0.3), // For CircularProgressIndicator track
//       ),
//       colorScheme:
//           ColorScheme.fromSwatch().copyWith(secondary: Colours.primaryColor),
//       primaryColor: Colours.primaryColor,
//       scaffoldBackgroundColor: Colours.lightGray,
//       appBarTheme: appBarLightTheme,
//       iconTheme: const IconThemeData(color: Colours.textBlackColor),
//       elevatedButtonTheme: elevatedButtonThemeData,
//
//     );
//   }
// }
