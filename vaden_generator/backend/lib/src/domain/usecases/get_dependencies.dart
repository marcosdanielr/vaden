import 'package:backend/src/domain/dtos/dependency_dto.dart';
import 'package:backend/src/domain/repositories/dependency_repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:vaden/vaden.dart';

@Component()
class GetDependencies {
  final DependencyRepository _generateRepository;

  GetDependencies(this._generateRepository);

  AsyncResult<List<DependencyDTO>> call() async {
    final dependencies = await _generateRepository.getDependencies();
    return dependencies.map(DependencyDTO.fromDependencies);
  }
}
