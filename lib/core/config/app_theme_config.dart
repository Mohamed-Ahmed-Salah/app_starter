import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../constants/size_constants.dart';
import '../res/colours.dart';

class AppThemeConfig {
  AppThemeConfig._();

  static final AppThemeConfig instance = AppThemeConfig._();

  ThemeData get appTheme => _getDefaultTheme();

  /// Set to the family name declared under `flutter: fonts:` in pubspec.yaml
  /// once the brand font is added; null falls back to the platform font.
  static const String? _fontFamily = null;

  CupertinoThemeData _buildCupertinoTheme(Color primaryColor) {
    return CupertinoThemeData(
      primaryColor: primaryColor,
      brightness: Brightness.light,
      applyThemeToAll: true,
    );
  }

  SwitchThemeData _buildSwitchTheme() {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colours.kWhite;
        }
        return Colours.grey200;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return null;
        }
        return Colours.grey300;
      }),
    );
  }

  /// Warm-black slider styling for the filter sheet's price [RangeSlider]
  /// (and any future [Slider]): dark active track on a light grey track, no
  /// tick marks even when divisions are set, and the design's two-tone thumb
  /// (white circle + centered warm-black dot — custom-painted, since stock
  /// shapes only support a single solid colour).
  SliderThemeData _buildSliderTheme() {
    return SliderThemeData(
      trackHeight: SizeConstants.sliderTrackHeight,
      activeTrackColor: Colours.warmBlack,
      inactiveTrackColor: Colours.grey200,
      thumbColor: Colours.warmBlack,
      overlayColor: Colors.transparent,
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
      valueIndicatorColor: Colours.warmBlack,
    );
  }

  ProgressIndicatorThemeData _buildProgressIndicatorTheme(Color primaryColor) {
    return ProgressIndicatorThemeData(
      color: primaryColor,
      linearTrackColor: primaryColor.withValues(alpha: 0.4),
      circularTrackColor: primaryColor.withValues(alpha: 0.3),
    );
  }

  ListTileThemeData _buildListTileTheme() {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConstants.innerBorderRadius),
      ),
    );
  }

  AppBarTheme _buildAppBarTheme(String? fontFamily) {
    return AppBarTheme(
      backgroundColor: Colours.scaffoldBackground,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colours.textBlackColor, size: 17.sp),
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colours.textBlackColor,
        fontFamily: fontFamily,
      ),
    );
  }

  IconThemeData _buildIconTheme() {
    return IconThemeData(color: Colours.textBlackColor, size: 20.sp);
  }

  TextTheme _buildTextTheme() {
    return TextTheme(
      labelSmall: TextStyle(
        color: Colours.textBlackColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: TextStyle(
        color: Colours.textBlackColor,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: Colours.textBlackColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      titleSmall: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: Colours.textBlackColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: Colours.textBlackColor,
      ),
      titleLarge: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(
        fontSize: 21.5.sp,
        fontWeight: FontWeight.w400,
        color: Colours.textBlackColor,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 22.sp,
        color: Colours.textBlackColor,
      ),
      headlineLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 23.sp),
      bodySmall: TextStyle(
        color: Colours.textBlackColor,
        fontSize: 13.5.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(color: Colours.textBlackColor, fontSize: 14.sp),
      bodyLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
      displaySmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.sp),
      displayMedium: TextStyle(
        color: Colours.textBlackColor,
        fontSize: 25.sp,
        fontWeight: FontWeight.w400,
      ),
      displayLarge: TextStyle(
        color: Colours.textBlackColor,
        fontSize: 31.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  ElevatedButtonThemeData _buildElevatedButtonTheme(
    Color primaryColor,
    String? fontFamily,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colours.kBlack,
        disabledBackgroundColor: Colours.kBlack.withValues(alpha: 0.6),
        disabledForegroundColor: Colours.kWhite,
        foregroundColor: Colours.kWhite,
        padding: EdgeInsetsGeometry.symmetric(vertical: 10.sp),
        minimumSize: Size(double.infinity, 20),
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: Colours.kWhite,
          fontFamily: fontFamily,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(SizeConstants.fullBorderRadius),
          ),
        ),
      ),
    );
  }

  TextButtonThemeData _buildTextButtonTheme(String? fontFamily) {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled))
            return Colours.textTertiary;
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return Colours.warmBlack900;
          }
          return Colours.textSecondary;
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return Colours.grey100;
          }
          return Colors.transparent;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConstants.radiusFull),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  OutlinedButtonThemeData _buildOutlinedButtonTheme(String? fontFamily) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colours.warmBlack900.withValues(alpha: 0.5);
          }
          return Colours.warmBlack900;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              width: 1.5,
              color: Colours.warmBlack900.withValues(alpha: 0.5),
            );
          }
          return const BorderSide(width: 1.5, color: Colours.warmBlack900);
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return Colours.grey100;
          }
          return Colors.transparent;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConstants.radiusFull),
          ),
        ),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 20)),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 10.sp)),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: 16.sp,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  IconButtonThemeData _buildIconButtonTheme() {
    return IconButtonThemeData(
      style: ButtonStyle(
        // iconSize: const WidgetStatePropertyAll(SizeConstants.iconSizeLarge),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colours.warmBlack900.withValues(alpha: 0.4);
          }
          return Colours.warmBlack900;
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return Colours.grey100;
          }
          return Colors.transparent;
        }),
      ),
    );
  }

  InputDecorationTheme _buildInputDecorationTheme(String? fontFamily) {
    return InputDecorationTheme(
      fillColor: Colours.kWhite,
      filled: true,
      isDense: true,
      errorMaxLines: 3,
      labelStyle: TextStyle(
        color: Colours.textBlackColor,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
      ),
      hintStyle: TextStyle(
        color: Colours.textTertiary,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
      ),
      prefixIconColor: Colours.textTertiary,
      suffixIconColor: Colours.textTertiary,
      errorStyle: TextStyle(
        color: Colours.errorColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConstants.outerBorderRadius),
        ),
        borderSide: BorderSide(width: 1.5, color: Colours.borderGreyColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConstants.outerBorderRadius),
        ),
        borderSide: BorderSide(width: 1.5, color: Colours.borderGreyColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConstants.outerBorderRadius),
        ),
        borderSide: const BorderSide(width: 1.5, color: Colours.kBlack),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConstants.outerBorderRadius),
        ),
        borderSide: const BorderSide(width: 1.5, color: Colours.errorColor),
      ),
    );
  }

  DatePickerThemeData _buildDatePickerTheme() {
    return DatePickerThemeData(
      headerHelpStyle: const TextStyle(fontSize: 14),
      headerHeadlineStyle: const TextStyle(fontSize: 18),
      cancelButtonStyle: ButtonStyle(
        textStyle: WidgetStateProperty.all(TextStyle(fontSize: 14)),
      ),
      confirmButtonStyle: ButtonStyle(
        textStyle: WidgetStateProperty.all(TextStyle(fontSize: 14)),
      ),
    );
  }

  ThemeData _buildTheme({
    required Color primaryColor,
    MaterialColor? primarySwatch,
    String? fontFamily,
  }) {
    return ThemeData(
      brightness: Brightness.light,
      cupertinoOverrideTheme: _buildCupertinoTheme(primaryColor),
      switchTheme: _buildSwitchTheme(),
      sliderTheme: _buildSliderTheme(),
      progressIndicatorTheme: _buildProgressIndicatorTheme(primaryColor),
      listTileTheme: _buildListTileTheme(),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primarySwatch ?? Colours.primaryColorSwatch,
      ),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colours.scaffoldBackground,
      appBarTheme: _buildAppBarTheme(fontFamily),
      iconTheme: _buildIconTheme(),
      textTheme: _buildTextTheme(),
      tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colours.textBlackColor,
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(primaryColor, fontFamily),
      textButtonTheme: _buildTextButtonTheme(fontFamily),
      outlinedButtonTheme: _buildOutlinedButtonTheme(fontFamily),
      iconButtonTheme: _buildIconButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(fontFamily),
      datePickerTheme: _buildDatePickerTheme(),
      fontFamily: fontFamily,
      dividerTheme: DividerThemeData(
        color: Colours.borderGreyColor,
        thickness: 1,
        // line width
        space: 16,
        // total height including padding
        indent: 0,
        // left padding
        endIndent: 0, // right padding
      ),
    );
  }

  ThemeData _getDefaultTheme() {
    return _buildTheme(
      primaryColor: Colours.primaryColor,
      primarySwatch: Colours.primaryColorSwatch,
      fontFamily: _fontFamily,
    );
  }
}
