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
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  AsyncResult<List<DependencyDTO>> getDependencies() async {
    return _clientHttp //
        .get('/v1/generate/dependencies')
        .flatMap(_dependenciesFromResponse);
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
