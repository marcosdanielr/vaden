import 'package:backend/src/domain/dtos/project_link_dto.dart';
import 'package:backend/src/domain/entities/project.dart';
import 'package:backend/src/domain/services/generate_service.dart';
import 'package:result_dart/result_dart.dart';
import 'package:vaden/vaden.dart';

@Service()
class GenerateServiceImpl implements GenerateService {
  @override
  AsyncResult<ProjectWithTempPath> addDependencies(ProjectWithTempPath project) {
    // TODO: implement addDependencies
    throw UnimplementedError();
  }

  @override
  AsyncResult<ProjectWithTempPath> createTempProject(Project project) {
    // TODO: implement createTempProject
    throw UnimplementedError();
  }

  @override
  AsyncResult<ProjectLinkDTO> createZipLink(ProjectWithTempPath project) {
    // TODO: implement createZipLink
    throw UnimplementedError();
  }
}
