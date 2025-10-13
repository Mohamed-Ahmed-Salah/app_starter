// Network Call Handler for Remote Data Source
import 'dart:async';
import 'dart:io';

import 'package:app_starter/config/errors/error_const.dart';
import 'package:app_starter/config/errors/exceptions.dart';
import 'package:app_starter/config/network/network_constants.dart';
import 'package:app_starter/config/utils/util_functions.dart';
import 'package:dio/dio.dart';

mixin NetworkCallHandler {
  /// Handles all network calls with standardized error handling
  Future<T> handleNetworkCall<T>({
    required Future<Response> Function() call,
    required T Function(Response response) onSuccess,
  }) async {
    try {
      final response = await call().timeout(
        const Duration(seconds: NetworkConstants.timeout),
      );
      print("RESPONSE++ ${response.data}");

      if (response.data[NetworkConstants.successParam] ?? false) {
        return onSuccess(response);
      } else {
        throw ServerException(
          message: response.data[NetworkConstants.messageParam] ?? '',
          statusCode: response.statusCode ?? 0,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    } on ServerException {
      rethrow;
    } on GeneralException {
      rethrow;
    } on FormatException {
      throw FormatParserException(
        message: 'Parsing failed',
        statusCode: ErrorConst.parsingErrorCode,
      );
    } on FormatParserException {
      rethrow;
    } on NoInternetException {
      rethrow;
    } on TimeOutException {
      rethrow;
    } on TimeoutException {
      throw const TimeOutException(
        message: ErrorConst.timeoutMessageEn,
        statusCode: ErrorConst.timeout,
      );
    } catch (e) {
      UtilFunctions.appLog("ERROR CATCH ${e.toString()}");
      throw const ServerException(
        message: ErrorConst.unknowErrorEn,
        statusCode: ErrorConst.unknownStatusCode,
      );
    }
  }

  Never _handleDioException(DioException e) {
    UtilFunctions.appLog(
      "_handleDioException: ${e.response?.data[NetworkConstants.dataParam]?[NetworkConstants.errorsListParam]}",
    );
    UtilFunctions.appLog(
      "${((e.response?.data[NetworkConstants.successParam] ?? true) == false) && e.response?.data[NetworkConstants.dataParam]?[NetworkConstants.errorsListParam] != null}",
    );

    /// Check for GeneralException case
    ///to make sure the error if not success to show general exception
    ///if null then just dont go inside if to make sure we handle error correctly
    if (((e.response?.data[NetworkConstants.successParam] ?? true) == false) &&
        e.response?.data[NetworkConstants.dataParam]?[NetworkConstants
                .errorsListParam] !=
            null) {
      throw GeneralException(
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
      );
    }

    UtilFunctions.appLog("DioException ${e.response?.data}");

    // Check for timeout
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const TimeOutException(
        message: ErrorConst.timeoutMessageEn,
        statusCode: ErrorConst.timeout,
      );
    }

    // Check for no internet
    if (e.response == null && e.error.runtimeType == SocketException) {
      throw NoInternetException(
        message: ErrorConst.noInternetMessageEn,
        statusCode: e.response?.statusCode ?? ErrorConst.noInternet,
      );
    }

    // Default server error
    String status = e.response?.data["message"] ?? ErrorConst.unknowErrorEn;
    throw ServerException(
      message: status,
      statusCode: e.response?.statusCode ?? ErrorConst.unknownStatusCode,
    );
  }
}
