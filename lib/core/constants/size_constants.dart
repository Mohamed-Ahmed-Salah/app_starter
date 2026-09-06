/// Design tokens: spacing (padding, gaps), border radii, and small control
/// geometry (icon sizes, tap target, chip/badge padding). Nothing else.
///
/// Widgets take their height from content and their width from their parent.
/// When a dimension is genuinely needed, derive it at the call site from
/// `MediaQuery.sizeOf(context)` — a screen-ratio *factor* or a fixed box
/// height is not a token and must not be added here.
class SizeConstants {
  SizeConstants._internal();

  static final SizeConstants _instance = SizeConstants._internal();

  factory SizeConstants() {
    return _instance;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMITIVE TOKENS — 4px Grid
  // ═══════════════════════════════════════════════════════════════════════════

  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;   // screen padding , inner container padding
  static const double space5 = 20;
  static const double space6 = 24;   // subsection gap
  static const double space8 = 28;   // section gap
  static const double space10 = 40;
  static const double space11 = 44;
  static const double space12 = 48;
  static const double space13 = 52;
  static const double space14 = 56;
  static const double space16 = 64;

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER RADII
  // ═══════════════════════════════════════════════════════════════════════════

  static const double radiusSm = 4;
  static const double radiusMd = 8;           // inner radius
  static const double radiusLg = 12;          // inputs, chips
  static const double radiusXl = 16;          // cards
  static const double radius2xl = 20;
  static const double radius3xl = 24;         // dialogs
  static const double radiusSheet = 28;       // bottom-sheet top corners
  static const double radiusFull = 9999;      // pill buttons, avatars, badges

  // Legacy aliases
  static const double fullBorderRadius = radiusFull;
  static const double outerBorderRadius = radiusLg;
  static const double innerBorderRadius = radiusMd;

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC TOKENS: LAYOUT
  // ═══════════════════════════════════════════════════════════════════════════

  static const double screenPadding = space4;           // 16
  static const double sectionGap = space8;              // 28
  static const double sectionTopPadding = space6;       // 24
  static const double sectionBottomPadding = space6;    // 24
  static const double subsectionGap = space6;           // 24

  // ─── SEMANTIC TOKENS: SECTION HEADER ───
  static const double titleToContentGap = space4;       // 16
  static const double titleToSubtitleGap = space2;      // 8
  static const double titleToSubtitleGapMedium = space1; // 4

  // ─── SEMANTIC TOKENS: CARDS ───
  static const double cardPadding = space3;             // 12 (tight cards)
  static const double cardPaddingLoose = space4;        // 16
  static const double cardGap = space3;                 // 12
  static const double cardInnerPadding = space3;        // 12

  // ─── SEMANTIC TOKENS: LIST ITEMS ───
  static const double itemGap = space3;                 // 12
  static const double itemGapSmall = space2;            // 8

  // ─── SEMANTIC TOKENS: BUTTONS & INPUTS ───
  static const double buttonPaddingHorizontal = space6; // 24
  static const double buttonPaddingVertical = 14;       // 14 (not on 4px grid)
  static const double buttonGap = space3;               // 12
  static const double inputPaddingHorizontal = space4;  // 16
  static const double inputPaddingVertical = 14;        // 14
  static const double inputToLabelGap = space1;         // 4
  static const double inputToHelperGap = space1;        // 4

  // ─── SEMANTIC TOKENS: ICONS ───
  static const double iconSizeSmall = 16;
  static const double iconSizeMedium = 20;
  static const double iconSizeLarge = 24;
  static const double iconSizeExtraLarge = 28;
  static const double iconPadding = space2;             // 8
  static const double iconPaddingSmall = space1;             // 4

  // ─── SEMANTIC TOKENS: SHEETS, RADIOS, SLIDERS ───
  static const double sheetHandleWidth = space10;   // 40 (drag grabber)
  static const double sheetHandleHeight = space1;   // 4
  static const double radioSize = space6;           // 24 (outer circle)
  static const double radioDotSize = space3;        // 12 (selected fill)
  static const double radioBorderWidth = 2;
  static const double sliderTrackHeight = 3;
  static const double sliderThumbRadius = 13;          // 26px thumb per design
  static const double sliderThumbDotRadius = 8;        // 13 − 5px white ring

  // ─── SEMANTIC TOKENS: CHIPS ───
  static const double chipPaddingHorizontal = space3;   // 12
  static const double chipPaddingVertical = 6;          // 6
  static const double chipGap = space2;                 // 8

  // ─── SEMANTIC TOKENS: NAVIGATION ───
  static const double appBarPaddingHorizontal = space4; // 16
  static const double fabOffset = space4;               // 16
  static const double fabOffsetFromNav = space4;        // 16

  // ─── SEMANTIC TOKENS: PAGINATION ───
  /// Distance from the bottom of a scroll view at which the next page is
  /// requested.
  static const double paginationPrefetchExtent = 600;

  // ─── SEMANTIC TOKENS: BADGES ───
  static const double badgePaddingHorizontal = space2;  // 8
  static const double badgePaddingVertical = space1;    // 4

  /// Counts past this show as `99+`, so a nav badge can't widen enough to
  /// reach the neighbouring tab.
  static const int badgeMaxCount = 99;
  static const double badgeBorderWidth = 1.5;           // ring over imagery

  // ─── SEMANTIC TOKENS: DIVIDERS ───
  static const double dividerThickness = 1;

  // ═══════════════════════════════════════════════════════════════════════════
  // HIT TARGETS & ACCESSIBILITY
  // ═══════════════════════════════════════════════════════════════════════════

  static const double tapTargetMinimum = 44; // minimum tap target size

  // ═══════════════════════════════════════════════════════════════════════════
  // MOTION / ANIMATION
  // ═══════════════════════════════════════════════════════════════════════════

  static const Duration slideDuration = Duration(milliseconds: 600);
  static const Duration durationNormal = Duration(milliseconds: 300);
}
