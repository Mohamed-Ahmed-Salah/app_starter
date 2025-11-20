import 'dart:io';
import 'package:collection/collection.dart';

import 'package:attendance/core/config/enums.dart';
import 'package:attendance/core/constants/network_constants.dart';
import 'package:attendance/core/services/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class SaveImageHelper {
  SaveImageHelper._();

  /// Main entry point for saving documents
  static Future<bool> saveDocument({
    required String url,
    required String mime,
    required BuildContext context,
    String? sourceFileName,
  }) async {
    if (url.isEmpty) return false;

    ///auto Check and request permissions
    // final hasPermission = await _checkAndRequestPermissions();
    // if (!hasPermission) {
    //   _showPermissionDeniedDialog(context);
    //   return false;
    // }

    try {
      // Download file
      final header = await NetworkConstants.getHeadersWithAuth();
      var response = await sl<Dio>().get(
        url,
        options: Options(responseType: ResponseType.bytes, headers: header),
      );

      final mimeType = fromType(mime);
      if (mimeType == null) {
        return false;
      }
      // Generate file name
      final fileName = sourceFileName ?? _generateFileName(mimeType);

      // Save based on type
      if (mimeType == MimeType.png || mimeType == MimeType.jpeg) {
        return await _saveImage(
          SaveShareRequest(
            data: response.data,
            fileName: fileName,
            type: mimeType,
          ),
        );
      } else {
        return await _saveDocument(
          SaveShareRequest(
            data: response.data,
            fileName: fileName,
            type: mimeType,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving document: $e');
      return false;
    }
  }

  /// Main entry point for sharing documents
  static Future<bool> shareDocument({
    required String url,
    required DocumentType type,
    required BuildContext context,
  }) async {
    if (url.isEmpty) return false;

    try {
      final headers = await NetworkConstants.getHeadersWithAuth();
      var response = await sl<Dio>().get(
        url,
        options: Options(responseType: ResponseType.bytes, headers: headers),
      );

      final tempDir = await getTemporaryDirectory();
      final fileName = _generateFileName(_getMimeType(type));
      final file = File('${tempDir.path}/$fileName');

      await file.writeAsBytes(response.data);
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
      try {
        await tempDir.delete();
        await file.delete();
      } catch (e) {
        debugPrint('Error deleting temp file: $e');
      }
      return true;
    } catch (e) {
      debugPrint('Error sharing document: $e');
      return false;
    }
  }

  /// Generate unique file name based on document type
  static String _generateFileName(MimeType type) {
    final uuid = const Uuid().v4();
    switch (type) {
      case MimeType.pdf:
        return 'document_$uuid.pdf';
      case MimeType.microsoftExcel:
        return 'spreadsheet_$uuid.xls';
      case MimeType.microsoftWord:
        return 'document_$uuid.doc';
      case MimeType.png:
        return 'image_$uuid.png';
      case MimeType.jpeg:
        return 'image_$uuid.jpeg';

      case MimeType.csv:
        return 'spreadsheet_$uuid.csv';

      case MimeType.openDocSheets:
        return 'document_$uuid.docx';
      default:
        return 'document_$uuid.docx';
    }
  }

  /// Get file extension from document type
  static String _getFileExtension(MimeType type) {
    switch (type) {
      case MimeType.pdf:
        return 'pdf';
      case MimeType.microsoftExcel:
        return 'xlsx';
      case MimeType.microsoftWord:
        return 'docx';
      case MimeType.png:
        return 'png';
      case MimeType.jpeg:
        return 'jpeg';
      default:
        return "zip";
    }
  }

  /// Save image to gallery
  static Future<bool> _saveImage(SaveShareRequest request) async {
    try {
      final bytes = await compute(_prepareBytes, request.data);

      final result = await SaverGallery.saveImage(
        bytes,
        // Uint8List.fromList(response.data),
        quality: 60,
        androidRelativePath: "Pictures/attendanceCRM/images",
        skipIfExists: false,
        fileName: request.fileName,
      );
      return result.isSuccess;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return false;
    }
  }

  /// Save document to device storage
  static Future<bool> _saveDocument(SaveShareRequest request) async {
    try {
      final bytes = await compute(_prepareBytes, request.data);

      final result = await FileSaver.instance.saveAs(
        name: request.fileName,
        bytes: bytes,
        fileExtension: _getFileExtension(request.type),
        mimeType: request.type,
      );
      return result != null;
    } catch (e) {
      debugPrint('Error saving document: $e');
      return false;
    }
  }

  static MimeType _getMimeType(DocumentType type) {
    switch (type) {
      case DocumentType.pdf:
        return MimeType.pdf;
      case DocumentType.excel:
        return MimeType.microsoftExcel;
      case DocumentType.word:
        return MimeType.microsoftWord;
      case DocumentType.image:
        return MimeType.png;

      // default:
      // return MimeType.o
    }
  }

  /// Check and request necessary permissions
  // static Future<bool> _checkAndRequestPermissions() async {
  //   if (Platform.isAndroid) {
  //     // For Android 13+ (API 33+), no storage permission needed for media
  //     final androidInfo = await _getAndroidVersion();
  //
  //     if (androidInfo >= 33) {
  //       // Android 13+ - photos permission for images, no permission for documents
  //       final photosStatus = await Permission.photos.status;
  //       if (!photosStatus.isGranted) {
  //         final result = await Permission.photos.request();
  //         return result.isGranted;
  //       }
  //       return true;
  //     } else if (androidInfo >= 30) {
  //       // Android 11-12 - manage external storage
  //       final status = await Permission.manageExternalStorage.status;
  //       if (!status.isGranted) {
  //         final result = await Permission.manageExternalStorage.request();
  //         return result.isGranted;
  //       }
  //       return true;
  //     } else {
  //       // Android 10 and below - storage permission
  //       final status = await Permission.storage.status;
  //       if (!status.isGranted) {
  //         final result = await Permission.storage.request();
  //         return result.isGranted;
  //       }
  //       return true;
  //     }
  //   } else if (Platform.isIOS) {
  //     // iOS - photos permission for images
  //     final status = await Permission.photos.status;
  //     // print("SATUSSS ${status} ${status.isGranted}");
  //     // if (!status.isGranted) {
  //     //   final result = await Permission.photos.request();
  //     //   print("AAAAA");
  //     //   return result.isGranted;
  //     // }
  //     return true;
  //   }
  //   return false;
  // }

  /// Get Android version
  static Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      // You can use device_info_plus package for this
      return 33; // Default to 33 for now, implement with device_info_plus
    }
    return 0;
  }

  /// Show permission denied dialog
  // static void _showPermissionDeniedDialog(BuildContext context) {
  //   showCupertinoDialog(
  //     context: context,
  //     builder: (context) => CupertinoAlertDialog(
  //       title: const Text('Permission Required'),
  //       content: const Text(
  //         'Storage permission is required to save files. Please grant permission in app settings.',
  //       ),
  //       actions: [
  //         CupertinoDialogAction(
  //           child: const Text('Cancel'),
  //           onPressed: () => Navigator.pop(context),
  //         ),
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: const Text('Open Settings'),
  //           onPressed: () {
  //             openAppSettings();
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// Show success message
  // static void showSuccessMessage(BuildContext context, String message) {
  //   showCupertinoDialog(
  //     context: context,
  //     builder: (context) => CupertinoAlertDialog(
  //       title: const Text('Success'),
  //       content: Text(message),
  //       actions: [
  //         CupertinoDialogAction(
  //           child: const Text('OK'),
  //           onPressed: () => Navigator.pop(context),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  static Uint8List _prepareBytes(List<int> data) => Uint8List.fromList(data);

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

class SaveShareRequest {
  final List<int> data;
  final String fileName;
  final MimeType type;

  SaveShareRequest({
    required this.data,
    required this.fileName,
    required this.type,
  });
}
