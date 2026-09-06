/// Resolution for entity fields the API returns as a `{field}` / `{field}_ar`
/// pair. Entities keep both values and expose an accessor that delegates here,
/// so the fallback policy cannot drift between fields or between features.
class LocalizedText {
  const LocalizedText._();

  /// Prefer the active language, fall back to the other.
  ///
  /// Content is routinely published in one language before the other, so the
  /// fallback is deliberate rather than defensive. A blank value counts as
  /// missing: `name` is parsed as `json['name'] ?? ''`, so an unfilled English
  /// field arrives as `''` and a plain `??` would never reach the Arabic one.
  static String? pick({required bool isEn, String? en, String? ar}) {
    final preferred = isEn ? en : ar;
    if (preferred != null && preferred.isNotEmpty) return preferred;

    final fallback = isEn ? ar : en;
    if (fallback != null && fallback.isNotEmpty) return fallback;

    return null;
  }
}
