/// Project icon font — one glyph kept as the pattern.
///
/// Generate your own set from SVGs via IcoMoon, drop the `.ttf` in
/// `assets/fonts/`, keep the `AppIcons` family in pubspec.yaml, and add one
/// `static const IconData` per glyph here. Widgets never use this class
/// directly — they go through [Media], which names icons by *purpose*.
///
/// Usage:
///   Icon(AppIcons.infoCircle, size: SizeConstants.iconSizeLarge)
library;

import 'package:flutter/widgets.dart';

class AppIcons {
  AppIcons._();

  static const _kFontFam = 'AppIcons';
  static const String? _kFontPkg = null;

  /// InfoCircle.svg
  static const IconData infoCircle = IconData(
    0xe978,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
}
