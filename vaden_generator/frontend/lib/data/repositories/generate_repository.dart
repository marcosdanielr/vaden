import 'package:frontend/domain/dtos/dependency_dto.dart';
import 'package:frontend/domain/dtos/project_dto.dart';
import 'package:frontend/domain/dtos/project_link_dto.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class GenerateRepository {
  AsyncResult<List<DependencyDTO>> getDependencies();

  AsyncResult<ProjectLinkDTO> create(ProjectDto dto);
}
