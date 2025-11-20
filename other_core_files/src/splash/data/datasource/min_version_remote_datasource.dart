import 'dart:async';
import 'dart:io';
import 'package:attendance/core/utils/util_functions.dart';

import 'package:attendance/core/constants/network_constants.dart';
import 'package:attendance/core/errors/exceptions.dart';
import 'package:attendance/src/splash/domain/entities/min_version_entity.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/error_const.dart';
import '../model/min_version_response.dart';
class MinVersionRemoteDataSrcImpl implements MinVersionRemoteDataSrc {
  const MinVersionRemoteDataSrcImpl(this._dio);

  final Dio _dio;

  @override
  Future<MinVersionEntity> minVersion() async {
    try {
      final header = await NetworkConstants.getHeaders();
      final response = await _dio
          .post(
        NetworkConstants.url,
        options: Options(headers: header),
      )
          .timeout(const Duration(seconds: NetworkConstants.timeout));

      if (response.statusCode == 200) {
        return MinVersionResponse();
      } else {
        throw ServerException(
          message: response.data['message'] ?? '',
          statusCode: response.statusCode ?? 0,
        );
      }
    } on DioException catch (e) {
      UtilFunctions.appLog("DioException ${e.response?.data}");

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const TimeOutException(
          message: ErrorConst.timeoutMessageEn,
          statusCode: 0,
        );
      }
      if (e.response == null) {
        if (e.error.runtimeType == SocketException) {
          throw NoInternetException(
            message: ErrorConst.noInternetMessageEn,
            statusCode: e.response?.statusCode ?? 400,
          );
        }
      }
      String status = e.response?.data["message"] ?? ErrorConst.unknowErrorEn;
      throw ServerException(message: status, statusCode: 500);
    } on ServerException {
      rethrow;
    } on NoInternetException {
      rethrow;
    } on TimeOutException {
      rethrow;
    } on TimeoutException {
      throw throw const TimeOutException(
        message: ErrorConst.timeoutMessageEn,
        statusCode: 20,
      );
    } catch (e) {
      UtilFunctions.appLog("ERROR CATCH ${e.toString()}");

      throw const ServerException(
        message: ErrorConst.unknowErrorEn,
        statusCode: 500,
      );
    }
  }

}

abstract class MinVersionRemoteDataSrc {
  const MinVersionRemoteDataSrc();

  Future<MinVersionEntity> minVersion();

}
