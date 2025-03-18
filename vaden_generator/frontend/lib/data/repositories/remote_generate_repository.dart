import 'package:frontend/config/constants.dart';
import 'package:frontend/data/repositories/generate_repository.dart';
import 'package:frontend/data/services/client_http.dart';
import 'package:frontend/data/services/url_launcher_service.dart';
import 'package:frontend/domain/entities/dependency.dart';
import 'package:frontend/domain/entities/project.dart';
import 'package:result_dart/result_dart.dart';

class RemoteGenerateRepository implements GenerateRepository {
  final Constants _constants;
  final ClientHttp _clientHttp;
  final UrlLauncherService _urlLauncherService;

  RemoteGenerateRepository(
      this._constants, this._clientHttp, this._urlLauncherService);

  @override
  AsyncResult<Unit> createZip(Project project) {
    return _clientHttp //
        .post(ClientRequest(path: '/v1/generate/create', data: project.toMap()))
        .flatMap(_getProjectLink)
        .flatMap(_urlLauncherService.launch);
  }

  @override
  AsyncResult<List<Dependency>> getDependencies() async {
    return _clientHttp //
        .get(ClientRequest(path: '/v1/generate/dependencies'))
        .flatMap(_dependenciesFromResponse);
  }

  Result<String> _getProjectLink(ClientResponse onSuccess) {
    try {
      final String baseUrl = _constants.urlBase;
      final String path = '/resource/uploads/';
      final String fileName = onSuccess.data['url'];
      final String projectName = onSuccess.request.data['projectName'];

      return Success('$baseUrl$path$fileName?name=$projectName');
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<List<Dependency>> _dependenciesFromResponse(
      ClientResponse response) async {
    try {
      final List<Dependency> dependencies = (response.data as List)
          .map((dependencyMap) => Dependency.fromMap(dependencyMap))
          .toList();
      return Success(dependencies);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
