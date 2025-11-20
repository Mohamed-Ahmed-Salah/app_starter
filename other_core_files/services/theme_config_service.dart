import 'package:attendance/core/constants/size_constants.dart';
import 'package:attendance/core/res/styles/colours.dart';
import 'package:attendance/core/services/cache_service.dart';
import 'package:attendance/core/services/hive_data_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../config/organization_theme_config.dart';
import '../constants/default_theme_firebase_constants.dart';
import 'package:flutter/material.dart';
import 'package:attendance/core/utils/util_functions.dart';

class ThemeConfigService with ChangeNotifier {
  final HiveDataService _hiveDataService;
  final CacheService _cacheService;

  ThemeConfigService({
    // required FirebaseRemoteConfigService remoteConfigService,
    required HiveDataService hiveDataService,
    required CacheService cacheService,
  }) : _hiveDataService = hiveDataService,
       _cacheService = cacheService;

  OrganizationThemeConfig? _currentThemeConfig;
  ThemeData? _currentTheme;

  OrganizationThemeConfig? get currentThemeConfig => _currentThemeConfig;

  ThemeData get currentTheme => _currentTheme ?? _getDefaultTheme();

  Future<void> initialize() async {
    try {
      // Try to get theme from Remote Config first
      UtilFunctions.appLog('ℹ️ Loading Saved Theme');

      final id = await _cacheService.getOrganizationId();
      final remoteThemeConfig = _hiveDataService.getThemeConfig(id);

      _currentThemeConfig = remoteThemeConfig;
      // Save to Hive for offline use
      // await _hiveService.saveThemeConfig(remoteThemeConfig);

      // If both Remote Config and Hive fail, use defaults (null config)
      _currentTheme = _buildThemeFromConfig(_currentThemeConfig);
      UtilFunctions.appLog('✅ Successfully fetched theme');

      notifyListeners();
    } catch (e) {
      UtilFunctions.appLog('❌ Error initializing theme service: $e');
      // Use defaults on error
      _currentThemeConfig = null;
      _currentTheme = _getDefaultTheme();
      notifyListeners();
    }
  }

  ThemeData getCurrentTheme() {
    return _buildThemeFromConfig(_currentThemeConfig);
  }

  Color? _parseColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) return null;

    try {
      String hex = colorHex.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex'; // Add alpha if not present
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      UtilFunctions.appLog('Error parsing color: $colorHex');
      return null;
    }
  }

  Future<void> refreshTheme() async {
    await initialize();
  }

  ThemeData _getDefaultTheme() {
    return ThemeData(
      brightness: Brightness.light,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: Colours.primaryColor,
        linearTrackColor: Colours.primaryColor.withValues(alpha: 0.4),
        circularTrackColor: Colours.primaryColor.withValues(alpha: 0.3),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            SizeConstants.innerBorderRadius,
          ), // 👈 splash respects this
        ),
      ),

      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colours.primaryColor,
      ),
      primaryColor: Colours.primaryColor,
      scaffoldBackgroundColor: Colours.scaffoldBackground,

      appBarTheme: AppBarTheme(
        backgroundColor: Colours.scaffoldBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colours.textBlackColor, size: 17.sp),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colours.textBlackColor,
        ),
      ),
      iconTheme: IconThemeData(color: Colours.textBlackColor, size: 17.sp),
      textTheme: TextTheme(
        labelSmall: TextStyle(
          color: Colours.textBlackColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w300,
        ),
        labelMedium: TextStyle(
          color: Colours.textBlackColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.w300,
        ),
        labelLarge: TextStyle(
          color: Colours.textBlackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w300,
        ),

        titleSmall: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w300,
          color: Colours.textBlackColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w300,
          color: Colours.textBlackColor,
        ),
        titleLarge: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w300),
        headlineSmall: TextStyle(
          fontSize: 21.5.sp,
          fontWeight: FontWeight.w300,
          color: Colours.textBlackColor,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 22.sp,
          color: Colours.textBlackColor,
        ),
        headlineLarge: TextStyle(fontWeight: FontWeight.w300, fontSize: 23.sp),
        bodySmall: TextStyle(
          color: Colours.textBlackColor,
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w300,
        ),
        bodyMedium: TextStyle(color: Colours.textBlackColor, fontSize: 14.sp),
        bodyLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300),
        displaySmall: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
        displayMedium: TextStyle(
          color: Colours.textBlackColor,
          fontSize: 25.sp,
        ),
        displayLarge: TextStyle(
          color: Colours.textBlackColor,
          fontSize: 31.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colours.primaryColor,
          disabledBackgroundColor: Colours.primaryColor.withValues(alpha: 0.6),
          disabledForegroundColor: Colours.kBlack,
          foregroundColor: Colours.kBlack,
          minimumSize: Size(double.infinity, 50),
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colours.kWhite,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(SizeConstants.outerBorderRadius),
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colours.kWhite,
        filled: true,

        labelStyle: const TextStyle(
          color: Colours.textBlackColor,
          fontWeight: FontWeight.w500,
          fontFamily: DefaultThemeConstants.fontFamily,
        ),
        hintStyle: TextStyle(
          color: Colours.hintTextColor,
          fontWeight: FontWeight.w500,
          fontFamily: DefaultThemeConstants.fontFamily,
        ),
        errorStyle: TextStyle(
          color: Colours.errorColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: DefaultThemeConstants.fontFamily,
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
      ),
    );
  }

  ThemeData _buildThemeFromConfig(OrganizationThemeConfig? config) {
    if (config == null) {
      UtilFunctions.appLog("Empty theme will call Defaults.");
      return _getDefaultTheme();
    }

    // Parse primary color
    Color primaryColor =
        _parseColor(config.primaryColor) ?? Colours.primaryColor;
    Color secondaryColor =
        _parseColor(config.secondaryColor) ?? Colours.secondaryColor;

    // Build color swatch if available
    MaterialColor? primarySwatch;
    if (config.primaryColorSwatch.isNotEmpty) {
      primarySwatch = _buildMaterialColor(
        primaryColor,
        config.primaryColorSwatch,
      );
    }

    return ThemeData(
      brightness: Brightness.light,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: primaryColor.withValues(alpha: 0.4),
        circularTrackColor: primaryColor.withValues(alpha: 0.3),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            SizeConstants.innerBorderRadius,
          ), // 👈 splash respects this
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primarySwatch ?? Colours.primaryColorSwatch,
      ).copyWith(secondary: secondaryColor),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colours.scaffoldBackground,
      appBarTheme: AppBarTheme(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colours.scaffoldBackground,

        iconTheme: IconThemeData(color: Colours.textBlackColor, size: 17.sp),
        titleTextStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colours.textBlackColor,
          fontFamily: config.fontFamily,
        ),
      ),
      iconTheme: IconThemeData(color: Colours.textBlackColor, size: 17.sp),
      textTheme: TextTheme(
        labelSmall: TextStyle(
          color: Colours.textBlackColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w300,
        ),
        labelMedium: TextStyle(
          color: Colours.textBlackColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.w300,
        ),
        labelLarge: TextStyle(
          color: Colours.textBlackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w300,
        ),
        titleSmall: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w300,
          color: Colours.textBlackColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w300,
          color: Colours.textBlackColor,
        ),
        titleLarge: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w300),
        headlineSmall: TextStyle(
          fontSize: 21.5.sp,
          fontWeight: FontWeight.w300,
          color: Colours.textBlackColor,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 23.sp,
          color: Colours.textBlackColor,
        ),
        headlineLarge: TextStyle(fontWeight: FontWeight.w300, fontSize: 23.sp),
        bodySmall: TextStyle(
          color: Colours.textBlackColor,
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w300,
        ),
        bodyMedium: TextStyle(color: Colours.textBlackColor, fontSize: 14.sp),
        bodyLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300),
        displaySmall: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
        displayMedium: TextStyle(
          color: Colours.textBlackColor,

          fontSize: 25.sp,
        ),
        displayLarge: TextStyle(
          color: Colours.textBlackColor,

          fontSize: 31.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colours.textBlackColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withValues(alpha: 0.6),
          disabledForegroundColor: Colours.kBlack,
          foregroundColor: Colours.kBlack,
          minimumSize: Size(double.infinity, 50),
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colours.kWhite,
            fontFamily: config.fontFamily,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(SizeConstants.outerBorderRadius),
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colours.kWhite,
        filled: true,

        labelStyle: const TextStyle(
          color: Colours.textBlackColor,
          fontWeight: FontWeight.w500,
          fontFamily: DefaultThemeConstants.fontFamily,
        ),
        hintStyle: TextStyle(
          color: Colours.hintTextColor,
          fontWeight: FontWeight.w500,
          fontFamily: DefaultThemeConstants.fontFamily,
        ),
        errorStyle: TextStyle(
          color: Colours.errorColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: DefaultThemeConstants.fontFamily,
        ),

        // prefixIconColor: AppColors.primaryColor,
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
      ),
      fontFamily: config.fontFamily,
    );
  }

  MaterialColor _buildMaterialColor(
    Color primaryColor,
    Map<String, String> swatchMap,
  ) {
    Map<int, Color> swatch = {};

    swatchMap.forEach((key, value) {
      int? shade = int.tryParse(key);
      Color? color = _parseColor(value);
      if (shade != null && color != null) {
        swatch[shade] = color;
      }
    });

    // Ensure we have all required shades
    for (int shade in [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]) {
      swatch.putIfAbsent(shade, () => primaryColor);
    }

    return MaterialColor(primaryColor.toARGB32(), swatch);
  }
}
