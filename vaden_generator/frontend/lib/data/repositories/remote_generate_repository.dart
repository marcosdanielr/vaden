import 'package:frontend/data/repositories/generate_repository.dart';
import 'package:frontend/data/services/client_http.dart';
import 'package:frontend/domain/dtos/dependency_dto.dart';
import 'package:frontend/domain/dtos/project_dto.dart';
import 'package:frontend/domain/dtos/project_link_dto.dart';
import 'package:result_dart/result_dart.dart';

class RemoteGenerateRepository implements GenerateRepository {
  final ClientHttp _clientHttp;

  RemoteGenerateRepository(this._clientHttp);

  @override
  AsyncResult<ProjectLinkDTO> create(ProjectDto dto) {
    final Map<String, dynamic> bodyMap = {
      'projectName': dto.name,
      'projectDescription': dto.description,
      'dartVersion': dto.dartVersion,
      'dependencies':
          dto.dependencies.map((dependency) => dependency.toMap()).toList(),
    };

    return _clientHttp //
        .post(ClientRequest(path: '/v1/generate/create', data: bodyMap))
        .flatMap(_projectLinkAdapter);
  }

  @override
  AsyncResult<List<DependencyDTO>> getDependencies() async {
    return _clientHttp //
        .get(ClientRequest(path: '/v1/generate/dependencies'))
        .flatMap(_dependenciesFromResponse);
  }

  Result<ProjectLinkDTO> _projectLinkAdapter(ClientResponse onSuccess) {
    try {
      final String baseUrl = const String.fromEnvironment('BASE_URL');
      final String path = '/resource/uploads/';
      final String fileName = onSuccess.data['url'];
      final String projectName = onSuccess.request.data['projectName'];

      return Success(
          ProjectLinkDTO('$baseUrl$path$fileName?name=$projectName'));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<List<DependencyDTO>> _dependenciesFromResponse(
      ClientResponse response) async {
    try {
      final List<DependencyDTO> dependencies = (response.data as List)
          .map((dependencyMap) => DependencyDTO.fromMap(dependencyMap))
          .toList();
      return Success(dependencies);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
