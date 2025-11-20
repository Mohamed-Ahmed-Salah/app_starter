import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/core/errors/error_const.dart';
import 'package:attendance/core/errors/exceptions.dart';
import 'package:attendance/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

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
