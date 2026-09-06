import 'package:flutter/material.dart';

abstract class Colours {
  // ═══════════════════════════════════════════════════════════════════════════
  // BRAND PALETTE — replace with the product's brand-book colours
  // ═══════════════════════════════════════════════════════════════════════════

  /// Mint — Primary brand/accent colour (never use as CTA, price, or text)
  static const Color mint = Color(0xFF9CDABC);

  /// Warm Black — Primary text and CTA colour
  static const Color warmBlack = Color(0xFF2D2525);

  /// Coral — Sale/urgency accent
  static const Color coral = Color(0xFFFF8072);

  /// Supporting brand colours
  static const Color aqua = Color(0xFF80CDD0);
  static const Color pinkBlush = Color(0xFFD47D99);
  static const Color atlantic = Color(0xFF2774AE);
  static const Color softRed = Color(0xFFC36D6A);
  static const Color laguna = Color(0xFF00B7BD);
  static const Color pinkBerry = Color(0xFFCF578A);
  static const Color lavender = Color(0xFF898CC3);
  static const Color magenta = Color(0xFFC800A1);
  static const Color gold = Color(0xFFC49A52);

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMARY COLOR
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color primaryColor = warmBlack;
  static const Color scaffoldBackground = Color(0xFFFBFAF6);

  /// Mint Material Colour Swatch
  static const MaterialColor primaryColorSwatch =
      MaterialColor(0xFF9CDABC, <int, Color>{
        50: Color(0xFFF3FBF7),
        100: Color(0xFFE4F6ED),
        200: Color(0xFFCDEEDD),
        300: Color(0xFFB4E6CC),
        400: Color(0xFF9CDABC),
        500: Color(0xFF7CCBA3),
        600: Color(0xFF5CB588),
        700: Color(0xFF43946C),
      });

  // ═══════════════════════════════════════════════════════════════════════════
  // MINT SCALE
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color mint50 = Color(0xFFF3FBF7);
  static const Color mint100 = Color(0xFFE4F6ED);
  static const Color mint200 = Color(0xFFCDEEDD);
  static const Color mint300 = Color(0xFFB4E6CC);
  static const Color mint400 = Color(0xFF9CDABC);
  static const Color mint500 = Color(0xFF7CCBA3);
  static const Color mint600 = Color(0xFF5CB588);
  static const Color mint700 = Color(0xFF43946C);

  // ═══════════════════════════════════════════════════════════════════════════
  // WARM BLACK SCALE
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color warmBlack900 = Color(0xFF2D2525);
  static const Color warmBlack800 = Color(0xFF3A3130);
  static const Color warmBlack700 = Color(0xFF4D4341);
  static const Color warmBlack600 = Color(0xFF6B5F5D);

  // ═══════════════════════════════════════════════════════════════════════════
  // CORAL SCALE
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color coral400 = Color(0xFFFF8072);
  static const Color coral500 = Color(0xFFF3675A);
  static const Color coral600 = Color(0xFFDF5346);

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPLEMENTARY SHADE SCALES
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color blush100 = Color(0xFFFCE8EE);
  static const Color blush200 = Color(0xFFF7D0DC);
  static const Color blush400 = Color(0xFFD47D99);
  static const Color blush500 = Color(0xFFC56484);
  static const Color berry500 = Color(0xFFCF578A);
  static const Color aqua400 = Color(0xFF80CDD0);
  static const Color gold400 = Color(0xFFD4A96A);
  static const Color gold500 = Color(0xFFC49A52);
  static const Color gold600 = Color(0xFFA6813E);

  // ═══════════════════════════════════════════════════════════════════════════
  // CREAM SCALE (Warm neutral surfaces)
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color cream50 = Color(0xFFFBFAF7);
  static const Color cream100 = Color(0xFFF6F2EB);
  static const Color cream200 = Color(0xFFEFE8DC);

  // ═══════════════════════════════════════════════════════════════════════════
  // SHIMMER / SKELETON (warm neutrals — kept warm to match Warm Black)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Skeleton base surface
  static const Color shimmerBase = Color(0xFFF0EFEC);

  /// Skeleton highlight sweep
  static const Color shimmerHighlight = Color(0xFFFBFAF7);

  /// Skeleton darker edge / divider on a skeleton
  static const Color shimmerEdge = Color(0xFFE7E5E0);

  /// Brand-tinted skeleton base (e.g. mint banner placeholders)
  static const Color shimmerMintBase = Color(0xFFCDEBDB);

  /// Brand-tinted skeleton highlight sweep
  static const Color shimmerMintHighlight = Color(0xFFE8F6EF);

  // ═══════════════════════════════════════════════════════════════════════════
  // GREY SCALE (UI neutrals)
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF515755);

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC: TEXT COLOURS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color textPrimary = Color(0xFF2D2525);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textPrice = Color(0xFFDF5346);
  static const Color textStrike = Color(0xFF9E9E9E);
  static const Color textLink = Color(0xFF2D2525);

  // Legacy aliases
  static const kWhite = Color(0xFFFFFFFF);
  static const kBlack = Color(0xFF2D2525);
  static const kTransparent = Color(0x00000000);

  static const Color textBlackColor = Color(0xFF2D2525);
  static const Color textHighlightColor = Color(0xFF515755);

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC: SURFACE COLOURS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color surfacePage = Color(0xFFFFFFFF);
  static const Color surfaceRaised = Color(0xFFFFFFFF);
  static const Color surfaceSunken = Color(0xFFF5F5F5);
  static const Color surfaceCream = Color(0xFFFBFAF7);
  static const Color surfaceMint = Color(0xFF9CDABC);

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC: BORDER COLOURS
  // ═══════════════════════════════════════════════════════════════════════════

  static Color borderSubtle = const Color(0xFF2D2525).withValues(alpha: 0.08);
  static Color borderDefault = const Color(0xFF2D2525).withValues(alpha: 0.12);
  static Color borderStrong = const Color(0xFF2D2525).withValues(alpha: 0.24);
  static Color borderInput = Colors.black.withValues(alpha: 0.10);
  static Color borderGreyColor = Colors.black.withValues(alpha: 0.1);

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC: STATUS COLOURS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color success = Color(0xFF0D7C66);
  static const Color successBg = Color(0xFFE4F6ED);
  static const Color error = Color(0xFFF54135);
  static const Color errorStrong = Color(0xFFCC1B2A);
  static const Color errorBg = Color(0xFFFDECEA);
  static const Color warning = Color(0xFFF2B325);
  static const Color warningBg = Color(0xFFFEF6E0);

  static const Color info = Color(0xFF2774AE);
  static const Color infoBg = Color(0xFFE8F1F8);

  // Legacy aliases
  static const Color errorColor = Color(0xFFF54135);
  static const Color greenSuccess = Color(0xFF0D7C66);
  static const Color yellowWarningColor = Color(0xFFF2B325);
  static const Color authAccentColor = Color(0xFFCC1B2A);

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC: INTERACTION COLOURS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color ctaBg = Color(0xFF2D2525);
  static const Color ctaBgHover = Color(0xFF3A3130);
  static const Color ctaFg = Color(0xFFFFFFFF);
  static const Color ctaBgDisabled = grey200;
  static Color ctaFgDisabled = textTertiary;
  static const Color badgeNewBg = Color(0xFF9CDABC);
  static const Color badgeSaleBg = Color(0xFFFF8072);

  // ═══════════════════════════════════════════════════════════════════════════
  // OVERLAY & UTILITY
  // ═══════════════════════════════════════════════════════════════════════════

  static Color surfaceOverlay = const Color(0xFF2D2525).withValues(alpha: 0.45);
  static Color textSecondary = const Color(0xFF2D2525).withValues(alpha: 0.62);
  static Color textTertiary = const Color(0xFF2D2525).withValues(alpha: 0.42);
  static Color hintTextColor = Colors.black.withValues(alpha: 0.5);
  static Color lightGreyTextColor = Colors.grey[600]!;

  // ═══════════════════════════════════════════════════════════════════════════
  // LEGACY / DEPRECATED (kept for compatibility)
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color secondaryColor = Color(0xFFE67E22);
  static const Color darkGrey = Color(0xFF757575);
  static const Color onboardingIconColor = Color(0xFFD81B60);
  static const Color onboardingBackground = Color(0xFFFCE4EC);
}
