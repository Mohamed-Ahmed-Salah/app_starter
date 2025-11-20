

import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/src/splash/domain/entities/min_version_entity.dart';
abstract class MinVersionRepo {
  ResultFuture<MinVersionEntity> minVersion();



}
