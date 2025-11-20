import 'dart:async';
import 'dart:io';

import 'package:attendance/core/constants/network_constants.dart';
import 'package:attendance/core/errors/error_const.dart';
import 'package:attendance/core/errors/exceptions.dart';
import 'package:attendance/core/services/auth_event_handler_service.dart';
import 'package:attendance/core/services/firebase_analytics_engine_service.dart';
import 'package:attendance/core/utils/util_functions.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Network Call Handler for Remote Data Source
mixin NetworkCallHandler {
  /// Handles all network calls with standardized error handling
  Future<T> handleNetworkCall<T>({
    required Future<Response> Function() call,
    required T Function(Response response) onSuccess,
    final int timeout = NetworkConstants.timeout,
  }) async {
    try {
      final response = await call().timeout(Duration(seconds: timeout));
      UtilFunctions.appLog(
        "RESPONSE++ ${response.data} ${response.data.runtimeType}",
      );

      if (response.data?[NetworkConstants.successParam] == true) {
        ///if success okay we try again to check if theres a problem when coverting from jso to model
        try {
          return onSuccess(response);
        } catch (e, stackTrace) {
          // This catches any exception during model parsing/conversion
          UtilFunctions.appLog(
            "Model parsing error: ${e.toString()} ${e.runtimeType}",
          );

          final exception = FormatParserException(
            message: 'Failed to parse response data: ${e.toString()}',
            statusCode: ErrorConst.parsingErrorCode,
            stackTrace: stackTrace,
          );

          // Log the parsing error with response data for debugging
          FirebaseAnalyticsEngineService.to.logError(
            exception,
            stackTrace,
            context: 'Model parsing failed',
            additionalData: {
              'response_data': response.data.toString(),
              'parsing_error': e.toString(),
            },
          );

          throw exception;
        }
      } else {
        throw ServerException(
          message: response.data[NetworkConstants.messageParam] ?? '',
          statusCode: response.statusCode ?? 0,
        );
      }
    } on DioException catch (e, stacktrace) {
      _handleDioException(e, stacktrace);
    } on ServerException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on GeneralException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on FormatException catch (e, stackTrace) {
      final exception = FormatParserException(
        message: 'Parsing failed',
        statusCode: ErrorConst.parsingErrorCode,
        stackTrace: stackTrace,
      );
      FirebaseAnalyticsEngineService.to.logError(exception, stackTrace);
      throw exception;
    } on FormatParserException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on UnauthenticatedException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on NoInternetException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on TimeOutException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on TimeoutException catch (e, stackTrace) {
      final exception = TimeOutException(
        message: ErrorConst.timeoutMessageEn,
        statusCode: ErrorConst.timeout,
        stackTrace: stackTrace,
      );
      FirebaseAnalyticsEngineService.to.logError(exception, stackTrace);
      throw exception;
    } catch (e, stackTrace) {
      UtilFunctions.appLog("ERROR CATCH ${e.toString()} } ${e.runtimeType}");
      final exception = ServerException(
        message: ErrorConst.unknowErrorEn,
        statusCode: ErrorConst.unknownStatusCode,
        stackTrace: stackTrace,
      );
      FirebaseAnalyticsEngineService.to.logError(
        exception,
        stackTrace,
        context: 'Unknown error in network call',
      );

      throw exception;
    }
  }

  /// Handles all network calls with standardized error handling
  Future<T> handleAiChatCall<T>({
    required Future<Response> Function() call,
    required T Function(Response response) onSuccess,
  }) async {
    try {
      final response = await call().timeout(const Duration(seconds: 180));
      print("RESPONSE++ ${response.data} ${response.data.runtimeType}");
      final data = response.data;

      if (data is Map<String, dynamic>) {
        if ((data[NetworkConstants.successParam] ?? false) ||
            response.statusCode == 200) {
          return onSuccess(response);
        }
      } else if (data is List && response.statusCode == 200) {
        // handle case when response is a list (like AI output)
        return onSuccess(response);
      }
      if (response.data?[NetworkConstants.successParam] ??
          false || response.statusCode == 200) {
        return onSuccess(response);
      } else {
        throw ServerException(
          message: response.data[NetworkConstants.messageParam] ?? '',
          statusCode: response.statusCode ?? 0,
        );
      }
    } on DioException catch (e, stacktrace) {
      _handleDioException(e, stacktrace);
    } on ServerException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on GeneralException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on FormatException catch (e, stackTrace) {
      final exception = FormatParserException(
        message: 'Parsing failed',
        statusCode: ErrorConst.parsingErrorCode,
        stackTrace: stackTrace,
      );
      FirebaseAnalyticsEngineService.to.logError(exception, stackTrace);
      throw exception;
    } on FormatParserException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on UnauthenticatedException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on NoInternetException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on TimeOutException catch (e, stackTrace) {
      FirebaseAnalyticsEngineService.to.logError(e, stackTrace);
      rethrow;
    } on TimeoutException catch (e, stackTrace) {
      final exception = TimeOutException(
        message: ErrorConst.timeoutMessageEn,
        statusCode: ErrorConst.timeout,
        stackTrace: stackTrace,
      );
      FirebaseAnalyticsEngineService.to.logError(exception, stackTrace);
      throw exception;
    } catch (e, stackTrace) {
      UtilFunctions.appLog("ERROR CATCH ${e.toString()} } ${e.runtimeType}");
      final exception = ServerException(
        message: ErrorConst.unknowErrorEn,
        statusCode: ErrorConst.unknownStatusCode,
        stackTrace: stackTrace,
      );
      FirebaseAnalyticsEngineService.to.logError(
        exception,
        stackTrace,
        context: 'Unknown error in network call',
      );

      throw exception;
    }
  }

  Never _handleDioException(DioException e, StackTrace stackTrace) {
    UtilFunctions.appLog(
      "_handleDioException: ${e.response?.data[NetworkConstants.dataParam]?[NetworkConstants.errorsListParam]} ${e.response} ${e.response?.statusCode}",
    );

    ///simply if user is not logged in.
    if (e.response?.statusCode == 401) {
      final exception = UnauthenticatedException(
        statusCode:
            e.response?.data[NetworkConstants.statusCode] ??
            ErrorConst.unauthenticated,
        message:
            e.response?.data[NetworkConstants.messageParam] ??
            "Unauthenticated.",
        stackTrace: stackTrace,
      );
      FirebaseAnalyticsEngineService.to.logError(
        exception,
        stackTrace,
        context: 'Unauthenticated (401)',
      );

      // Notify auth handler about 401 error for automatic logout and navigation
      AuthEventHandlerService.instance.handle401Error();

      throw exception;
    }

    /// Check for GeneralException case
    if (((e.response?.data[NetworkConstants.successParam] ?? true) == false) &&
        e.response?.data[NetworkConstants.dataParam]?[NetworkConstants
                .errorsListParam] !=
            null) {
      final exception = GeneralException(
        errors:
            (e.response?.data[NetworkConstants.dataParam][NetworkConstants
                        .errorsListParam]
                    as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        statusCode:
            e.response?.data[NetworkConstants.statusCode] ??
            ErrorConst.unknownStatusCode,
        message: e.response?.data[NetworkConstants.messageParam],
        stackTrace: stackTrace,
      );
      FirebaseAnalyticsEngineService.to.logError(
        exception,
        stackTrace,
        context: 'General Exception',
      );
      throw exception;
    }

    UtilFunctions.appLog("DioException ${e.response?.data}");

    // Check for timeout
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      final exception = TimeOutException(
        message: ErrorConst.timeoutMessageEn,
        statusCode: ErrorConst.timeout,
        stackTrace: stackTrace,
      );
      FirebaseAnalyticsEngineService.to.logError(
        exception,
        stackTrace,
        context: 'Connection timeout',
      );
      throw exception;
    }

    // Check for no internet
    if (e.response == null && e.error.runtimeType == SocketException) {
      final exception = NoInternetException(
        message: ErrorConst.noInternetMessageEn,
        statusCode: e.response?.statusCode ?? ErrorConst.noInternet,
        stackTrace: stackTrace,
      );
      FirebaseAnalyticsEngineService.to.logError(
        exception,
        stackTrace,
        context: 'No internet connection',
      );
      throw exception;
    }

    // Default server error
    String status = e.response?.data["message"] ?? ErrorConst.unknowErrorEn;
    final exception = ServerException(
      message: status,
      statusCode: e.response?.statusCode ?? ErrorConst.unknownStatusCode,
      stackTrace: stackTrace,
    );
    FirebaseAnalyticsEngineService.to.logError(
      exception,
      stackTrace,
      context: 'Server error',
    );
    throw exception;
  }

  /// Log exception to Firebase Crashlytics with context
  // void FirebaseAnalyticsEngineService.to.logError(
  //     dynamic exception,
  //     StackTrace stackTrace, {
  //       String? context,
  //     }) {
  //   // Add custom keys for better debugging
  //   if (context != null) {
  //     FirebaseCrashlytics.instance.setCustomKey('error_context', context);
  //   }
  //
  //   // Add exception type
  //   FirebaseCrashlytics.instance.setCustomKey('exception_type', exception.runtimeType.toString());
  //
  //   // Add specific details based on exception type
  //   if (exception is ServerException) {
  //     FirebaseCrashlytics.instance.setCustomKey('status_code', exception.statusCode);
  //     FirebaseCrashlytics.instance.setCustomKey('error_message', exception.message);
  //   } else if (exception is GeneralException) {
  //     FirebaseCrashlytics.instance.setCustomKey('status_code', exception.statusCode);
  //     FirebaseCrashlytics.instance.setCustomKey('errors', exception.errors.join(', '));
  //   } else if (exception is DioException) {
  //     FirebaseCrashlytics.instance.setCustomKey('dio_type', exception.type.toString());
  //     if (exception.response != null) {
  //       FirebaseCrashlytics.instance.setCustomKey('status_code', exception.response!.statusCode ?? 0);
  //       FirebaseCrashlytics.instance.setCustomKey('response_data', exception.response!.data.toString());
  //     }
  //   }
  //
  //   // Record the error with full stack trace
  //   FirebaseCrashlytics.instance.recordError(
  //     exception,
  //     stackTrace,
  //     reason: context,
  //     fatal: false,
  //   );
  // }
}
