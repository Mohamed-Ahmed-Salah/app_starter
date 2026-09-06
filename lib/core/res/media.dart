import 'package:flutter/material.dart';
import 'package:app_starter/core/res/app_icons.dart';

/// Every icon and image the UI uses, named by purpose. Widgets reference
/// [Media] members only — never `Icons.*`, `AppIcons.*` or a raw asset path —
/// so swapping a glyph or an asset is a one-line change here.
class Media {
  // ─── Icons ───
  /// Reusable
  static const IconData infoOutlineIcon = AppIcons.infoCircle;
  static const IconData checkMarkIcon = Icons.check;
  static const IconData xMarkIcon = Icons.clear;

  /// Unchangeable for direction and etc...
  static const IconData backIcon = Icons.arrow_back_ios_new_rounded;
  static const IconData forwardIcon = Icons.arrow_forward_ios_outlined;
  static const IconData imageBrokenIcon = Icons.image_not_supported_outlined;

  /// Feedback toasts
  static const IconData successToastIcon = Icons.check;
  static const IconData warningToastIcon = Icons.warning_amber_rounded;

  // ─── Images ───
  // TODO(starter): delete these placeholders once real assets exist.
  static const String _imgsBase = 'assets/imgs';
  static const String placeholder1Img = '$_imgsBase/placeholder_1.png';
  static const String placeholder2Img = '$_imgsBase/placeholder_2.png';

  /// Shown on splash. TODO(starter): point at the real logo.
  static const String appLogoImg = placeholder2Img;
}
