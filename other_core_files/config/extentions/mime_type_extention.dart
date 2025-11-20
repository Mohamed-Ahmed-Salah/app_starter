import 'package:file_saver/file_saver.dart';
import 'package:collection/collection.dart';

extension MimeTypeExtension on MimeType {
  /// Get MimeType enum from type string (e.g., "image/jpeg")
  static MimeType? fromType(String? typeString) {
    if (typeString == null || typeString.isEmpty) return null;

    return MimeType.values.firstWhereOrNull(
      (e) => e.type.toLowerCase() == typeString.toLowerCase(),
    );
  }

  /// Get MimeType enum from file extension (e.g., "jpg", ".jpg", "jpeg")
  static MimeType? fromExtension(String? extension) {
    if (extension == null || extension.isEmpty) return null;

    // Remove leading dot if present
    final ext = extension.startsWith('.')
        ? extension.substring(1).toLowerCase()
        : extension.toLowerCase();

    // Map common extensions to MimeType
    switch (ext) {
      case 'jpg':
        return MimeType.jpeg;
      case 'jpeg':
        return MimeType.jpeg;
      case 'png':
        return MimeType.png;
      case 'gif':
        return MimeType.gif;
      case 'bmp':
        return MimeType.bmp;
      case 'webp':
        return MimeType.webp;
      case 'heic':
        return MimeType.heic;
      case 'heif':
        return MimeType.heif;
      case 'svg':
        return MimeType.svg;
      case 'pdf':
        return MimeType.pdf;
      case 'docx':
        return MimeType.microsoftWord;
      case 'xlsx':
        return MimeType.microsoftExcel;
      case 'pptx':
        return MimeType.microsoftPresentation;
      case 'txt':
        return MimeType.text;
      case 'csv':
        return MimeType.csv;
      case 'zip':
        return MimeType.zip;
      case 'mp4':
        return MimeType.mp4Video;
      case 'mp3':
        return MimeType.mp3;
      default:
        return MimeType.other;
    }
  }
}
