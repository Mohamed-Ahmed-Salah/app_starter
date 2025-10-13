
import 'package:app_starter/config/network/typedefs.dart';
import 'package:app_starter/config/network/usecase.dart';
import 'package:app_starter/src/auth/domain/entity/login_request.dart';

import '../repo/auth_repo.dart';

class LoginUsecases extends UsecaseWithParams<String, LoginRequest> {
  const LoginUsecases(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<String> call(LoginRequest request) =>
      _repo.login(request: request);
}
