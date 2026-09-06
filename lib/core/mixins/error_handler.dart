
import 'package:fpdart/fpdart.dart';

import '../config/typedefs.dart';
import '../errors/error_const.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';

mixin ErrorHandler {
  /// Wraps repository calls with standardized error handling
  ResultFuture<T> handleRepoCall<T>(Future<T> Function() call) async {
    try {
      final response = await call();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } on NoInternetException catch (e) {
      return Left(NoInternetFailure.fromException(e));
    } on TimeOutException catch (e) {
      return Left(TimeOutFailure.fromException(e));
    } on GeneralException catch (e) {
      return Left(GeneralFailure.fromException(e));
    } on FormatParserException catch (e) {
      return Left(FormatParserFailure.fromException(e));
    } on UnauthenticatedException catch (e) {
      return Left(UnauthenticatedFailure.fromException(e));
    } on AuthException catch (e) {
      return Left(AuthFailure.fromException(e));
    } on AuthCancelledByUserException catch (e) {
      return Left(AuthCancelledByUserFailure.fromException(e));
    } catch (e) {
      return Left(
        ServerFailure.fromException(
          ServerException(message: e.toString(), statusCode: ErrorConst
              .unknownStatusCode),
        ),
      );
    }
  }
}
