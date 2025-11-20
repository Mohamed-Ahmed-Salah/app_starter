import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/core/config/usecase.dart';
import 'package:attendance/src/splash/domain/entities/min_version_entity.dart';
import 'package:attendance/src/splash/domain/repo/min_version_repo.dart';
class GetMinVersionUsecases extends UsecaseWithoutParams<MinVersionEntity> {
  const GetMinVersionUsecases(this._repo);

  final MinVersionRepo _repo;

  @override
  ResultFuture<MinVersionEntity> call() =>
      _repo.minVersion();
}
