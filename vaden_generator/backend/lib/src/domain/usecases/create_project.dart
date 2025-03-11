import 'package:backend/src/domain/dtos/generate_info_dto.dart';
import 'package:backend/src/domain/dtos/project_link_dto.dart';
import 'package:backend/src/domain/services/generate_service.dart';
import 'package:result_dart/result_dart.dart';
import 'package:vaden/vaden.dart';

@Component()
class CreateProject {
  final GenerateService _generateService;

  CreateProject(this._generateService);

  AsyncResult<ProjectLinkDTO> call(ProjectDTO dto) async {
    final project = dto.toProject();
    return _generateService //
        .createTempProject(project)
        .flatMap(_generateService.addDependencies)
        .flatMap(_generateService.createZipLink);
  }
}
