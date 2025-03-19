import '../../domain/dtos/dependency_dto.dart';
import '../../domain/dtos/project_dto.dart';
import '../../domain/dtos/project_link_dto.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class GenerateRepository {
  AsyncResult<List<Dependency>> getDependencies();

  AsyncResult<Unit> createZip(Project project);
}
