import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/core/errors/exceptions.dart';
import 'package:attendance/core/errors/failures.dart';
import 'package:attendance/src/splash/domain/entities/min_version_entity.dart';
import 'package:attendance/src/splash/domain/repo/min_version_repo.dart';
import 'package:dartz/dartz.dart';

import '../datasource/min_version_remote_datasource.dart';

class MinVersionRepoImpl implements MinVersionRepo {
  const MinVersionRepoImpl(this._remoteDataSource);

  final MinVersionRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<MinVersionEntity> minVersion() async {
    try {
      final response = await _remoteDataSource.minVersion(
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } on NoInternetException catch (e) {
      return Left(NoInternetFailure.fromException(e));
    } on TimeOutException catch (e) {
      return Left(TimeOutFailure.fromException(e));
    }  catch (e) {
      return Left(
        ServerFailure.fromException(
          ServerException(message: e.toString(), statusCode: 500),
        ),
      );
    }
  }
}
