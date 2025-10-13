import 'package:app_starter/config/network/typedefs.dart';
import 'package:app_starter/config/network/usecase.dart';
import 'package:app_starter/src/auth/domain/entity/registration_request.dart';

import '../repo/auth_repo.dart';

class RegisterUsecases extends UsecaseWithParams<String, RegistrationRequest> {
  const RegisterUsecases(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<String> call(RegistrationRequest request) =>
      _repo.register(request: request);
}
