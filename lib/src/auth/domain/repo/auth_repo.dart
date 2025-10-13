import 'package:app_starter/config/network/typedefs.dart';
import 'package:app_starter/src/auth/domain/entity/login_request.dart';
import 'package:app_starter/src/auth/domain/entity/registration_request.dart';

abstract class AuthRepo {
  ResultFuture<String> register({required RegistrationRequest request});
  ResultFuture<String> login({required LoginRequest request});
}
