import 'package:backend/src/domain/entities/dependency.dart';
import 'package:backend/src/domain/repositories/dependency_repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:vaden/vaden.dart';

@Component()
class GetDependencies {
  final DependencyRepository _generateRepository;

  GetDependencies(this._generateRepository);

  AsyncResult<List<Dependency>> call() async {
    return await _generateRepository.getDependencies();
  }
}
