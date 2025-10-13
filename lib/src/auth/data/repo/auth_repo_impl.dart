import 'package:app_starter/config/network/mixins/error_handler.dart';
import 'package:app_starter/config/network/typedefs.dart';
import 'package:app_starter/src/auth/data/datasource/auth_remote_datasource.dart';
import 'package:app_starter/src/auth/domain/entity/login_request.dart';
import 'package:app_starter/src/auth/domain/entity/registration_request.dart';
import 'package:app_starter/src/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl with ErrorHandler implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<String> register({required RegistrationRequest request}) async {
    return handleRepoCall(() => _remoteDataSource.register(request: request));
  }

  @override
  ResultFuture<String> login({required LoginRequest request}) async {
    return handleRepoCall(() => _remoteDataSource.login(request: request));
  }
}
