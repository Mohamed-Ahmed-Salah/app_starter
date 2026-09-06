import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

import '../constants/network_constants.dart';
import '../errors/error_const.dart';
import '../errors/exceptions.dart';
import '../monitoring/firebase_error_logger_service.dart';
import '../services/auth_event_handler_service.dart';
import '../services/injection_container.dart';
import '../utils/util_functions.dart';

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

      if (response.requestOptions.responseType == ResponseType.bytes) {
        ///expecting bytes
        return onSuccess(response);
      } else {
        ///its json
        if (response.data?[NetworkConstants.successParam] == true ||
            _isSuccessCode(response.statusCode ?? 0)) {
          ///if success okay we try again to check if theres a problem when converting from json to model
          try {
            return onSuccess(response);
          } catch (e, stackTrace) {
            final exception = FormatParserException(
              message: 'Failed to parse response data: ${e.toString()}',
              statusCode: ErrorConst.parsingErrorCode,
              stackTrace: stackTrace,
            );

            // Log the parsing error with response data for debugging
            FirebaseErrorLoggerService.to.logError(
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
      }
    } on DioException catch (e, stacktrace) {
      UtilFunctions.appLog(
        "DioException ERROR ${e.response?.statusCode} ${e.response?.data} ${e.type} ${e.error}",
      );
      _handleDioException(e, stacktrace);
    } on ServerException {
      rethrow;
    } on GeneralException {
      rethrow;
    } on FormatException catch (e, stackTrace) {
      final exception = FormatParserException(
        message: ErrorConst.parsingErrorMessageEn,
        statusCode: ErrorConst.parsingErrorCode,
        stackTrace: stackTrace,
      );
      FirebaseErrorLoggerService.to.logError(exception, stackTrace);
      throw exception;
    } on FormatParserException catch (e, stackTrace) {
      FirebaseErrorLoggerService.to.logError(e, stackTrace);
      rethrow;
    } on UnauthenticatedException {
      rethrow;
    } on NoInternetException {
      rethrow;
    } on TimeOutException {
      rethrow;
    } on TimeoutException catch (e, stackTrace) {
      final exception = TimeOutException(
        message: ErrorConst.timeoutMessageEn,
        statusCode: ErrorConst.timeout,
        stackTrace: stackTrace,
      );
      throw exception;
    } catch (e, stackTrace) {
      UtilFunctions.appLog("ERROR CATCH ${e.toString()} } ${e.runtimeType}");
      final exception = ServerException(
        message: ErrorConst.unknowErrorEn,
        statusCode: ErrorConst.unknownStatusCode,
        stackTrace: stackTrace,
      );
      FirebaseErrorLoggerService.to.logError(
        exception,
        stackTrace,
        context: 'Unknown error in network call',
      );

      throw exception;
    }
  }

  bool _isSuccessCode(int code) {
    return code >= 200 && code < 300;
  }

  Never _handleDioException(DioException e, StackTrace stackTrace) {
    final isBytesResponse = e.requestOptions.responseType == ResponseType.bytes;

    if (isBytesResponse) {
      UtilFunctions.appLog(
        "_handleDioException (bytes response): ${e.response?.statusCode}",
      );

      throw ServerException(
        message: ErrorConst.unknowErrorEn,
        statusCode: e.response?.statusCode ?? ErrorConst.unknownStatusCode,
        stackTrace: stackTrace,
      );
    } else {
      UtilFunctions.appLog(
        "_handleDioException: ${e.response?.data[NetworkConstants.dataParam]?[NetworkConstants.errorsListParam]}",
      );
    }

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
      unawaited(sl<AuthEventHandlerService>().handle401Error());

      throw exception;
    }

    /// Check for GeneralException case
    if ((e.response?.data[NetworkConstants.successParam] == false) ||
        e.response?.data[NetworkConstants.dataParam]?[NetworkConstants
                .errorsListParam] !=
            null) {
      UtilFunctions.appLog("GeneralException Error handled ");
      final exception = GeneralException(
        errors:
            e.response?.data[NetworkConstants.dataParam]?[NetworkConstants
                    .errorsListParam]
                is List<dynamic>
            ? (e.response?.data[NetworkConstants.dataParam]?[NetworkConstants
                              .errorsListParam]
                          as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .toList() ??
                  []
            : [],
        statusCode:
            e.response?.data[NetworkConstants.statusCode] ??
            e.response?.statusCode ??
            ErrorConst.unknownStatusCode,
        message: e.response?.data[NetworkConstants.messageParam],
        stackTrace: stackTrace,
      );
      UtilFunctions.appLog("GeneralException Error= $exception ");

      throw exception;
    }

    if (e.response?.data[NetworkConstants.messageParam] != null) {
      final exception = GeneralException(
        errors: [],
        statusCode: e.response?.statusCode ?? ErrorConst.unknownStatusCode,
        message: e.response?.data[NetworkConstants.messageParam],
        stackTrace: stackTrace,
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
      throw exception;
    }

    // Check for no internet
    if (e.response == null && e.error.runtimeType == SocketException) {
      final exception = NoInternetException(
        message: ErrorConst.noInternetMessageEn,
        statusCode: e.response?.statusCode ?? ErrorConst.noInternet,
        stackTrace: stackTrace,
      );
      throw exception;
    }

    // Default server error
    String status =
        e.response?.data[NetworkConstants.messageParam] ??
        ErrorConst.unknowErrorEn;
    final exception = ServerException(
      message: status,
      statusCode: e.response?.statusCode ?? ErrorConst.unknownStatusCode,
      stackTrace: stackTrace,
    );
    FirebaseErrorLoggerService.to.logError(
      exception,
      stackTrace,
      context: 'Server error',
    );
    throw exception;
  }
}
