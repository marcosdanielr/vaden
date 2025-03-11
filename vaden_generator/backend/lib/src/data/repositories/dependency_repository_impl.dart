import 'package:backend/src/domain/entities/dependency.dart';
import 'package:backend/src/domain/repositories/dependency_repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:vaden/vaden.dart';

@Repository()
class DependencyRepositoryImpl implements DependencyRepository {
  @override
  AsyncResult<List<Dependency>> getDependencies() {
    throw UnimplementedError();
  }
}
