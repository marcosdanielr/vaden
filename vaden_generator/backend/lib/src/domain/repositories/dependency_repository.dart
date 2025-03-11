import 'package:backend/src/domain/entities/dependency.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class DependencyRepository {
  AsyncResult<List<Dependency>> getDependencies();
}
