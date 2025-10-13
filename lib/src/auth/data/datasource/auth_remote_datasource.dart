import 'package:app_starter/config/network/mixins/network_handler.dart';
import 'package:app_starter/config/network/network_constants.dart';
import 'package:app_starter/src/auth/domain/entity/login_request.dart';
import 'package:app_starter/src/auth/domain/entity/registration_request.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSrcImpl
    with NetworkCallHandler
    implements AuthRemoteDataSrc {
  const AuthRemoteDataSrcImpl(this._dio);

  final Dio _dio;

  @override
  Future<String> register({required RegistrationRequest request}) async {
    final header = await NetworkConstants.getHeaders();

    return handleNetworkCall<String>(
      call: () => _dio.post(
        '${NetworkConstants.url}/auth/register',
        options: Options(headers: header),
        data: request.toJson(),
      ),
      onSuccess: (response) =>
          response.data[NetworkConstants.dataParam]["token"] as String,
    );
  }

  @override
  Future<String> login({required LoginRequest request}) async {
    final header = await NetworkConstants.getHeaders();

    return handleNetworkCall<String>(
      call: () => _dio.post(
        '${NetworkConstants.url}/auth/login',
        options: Options(headers: header),
        data: request.toJson(),
      ),
      onSuccess: (response) =>
          response.data[NetworkConstants.dataParam]["token"] as String,
    );
  }
}

abstract class AuthRemoteDataSrc {
  const AuthRemoteDataSrc();

  Future<String> register({required RegistrationRequest request});

  Future<String> login({required LoginRequest request});
}
