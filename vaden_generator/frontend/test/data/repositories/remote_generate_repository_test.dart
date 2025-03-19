import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/data/repositories/generate_repository.dart';
import 'package:frontend/data/repositories/remote_generate_repository.dart';
import 'package:frontend/data/services/client_http.dart';
import 'package:frontend/data/services/url_launcher_service.dart';
import 'package:frontend/domain/entities/dependency.dart';
import 'package:frontend/domain/entities/project.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../mock/response_mock.dart';

class MockClientHttp extends Mock implements ClientHttp {}

class MockConstants extends Mock implements Constants {}

class UrlLauncherServiceFake extends Fake implements UrlLauncherService {
  String url = '';

  @override
  AsyncResult<Unit> launch(String url) async {
    this.url = url;
    return Success(unit);
  }
}

class MockcDioException extends Mock implements DioException {}

class ClientRequestFake extends Fake implements ClientRequest {}

void main() {
  late ClientHttp clientHttp;
  late Constants constants;
  late UrlLauncherService urlLauncherService;
  late GenerateRepository generateRepository;

  setUpAll(() {
    registerFallbackValue(ClientRequestFake());
  });

  setUp(() {
    clientHttp = MockClientHttp();
    constants = MockConstants();
    urlLauncherService = UrlLauncherServiceFake();
    generateRepository =
        RemoteGenerateRepository(constants, clientHttp, urlLauncherService);
  });

  group('Get dependencies', () {
    test('Should return the dependencies when the response is success',
        () async {
      when(() => clientHttp.get(any()))
          .thenAnswer((_) async => Success(ClientResponse(
                data: ResponseMock.getDependencies,
                statusCode: 200,
                request: ClientRequestFake(),
              )));

      final dependencies = await generateRepository.getDependencies();

      expect(dependencies.isSuccess(), true);
      expect(dependencies.getOrNull(), isA<List<Dependency>>());
    });

    test('Should returnt dio exception when the response is fail', () async {
      when(() => clientHttp.get(any()))
          .thenAnswer((_) async => Failure(MockcDioException()));

      final dependencies = await generateRepository.getDependencies();

      expect(dependencies.isSuccess(), false);
      expect(dependencies.exceptionOrNull(), isA<DioException>());
    });

    test(
        'Should returnt exception when the response is different than expected',
        () async {
      when(() => clientHttp.get(any()))
          .thenAnswer((_) async => Success(ClientResponse(
                data: [{}],
                statusCode: 200,
                request: ClientRequestFake(),
              )));

      final dependencies = await generateRepository.getDependencies();

      expect(dependencies.isSuccess(), false);
      expect(dependencies.exceptionOrNull(), isNotNull);
    });
  });

  group('Create project', () {
    test('Should return the project link when the response is success',
        () async {
      when(() => constants.urlBase).thenAnswer((_) => 'https://api.vaden.dev');
      when(() => clientHttp.post(any()))
          .thenAnswer((_) async => Success(ClientResponse(
                data: ResponseMock.postCreate,
                statusCode: 200,
                request:
                    ClientRequest(path: '', data: {'projectName': 'project'}),
              )));

      final projectUrl = await generateRepository.createZip(Project());

      expect(projectUrl.isSuccess(), true);
      expect(projectUrl.getOrNull(), isA<Unit>());
      expect(
          (urlLauncherService as UrlLauncherServiceFake).url,
          'https://api.vaden.dev/resource/uploads/'
          '1a8ccfed-b200-4d57-83a6-99b65abafcf5.zip?name=project');
    });

    test('Should returnt dio exception when the response is fail', () async {
      when(() => clientHttp.post(any()))
          .thenAnswer((_) async => Failure(MockcDioException()));

      final projectUrl = await generateRepository.createZip(Project());

      expect(projectUrl.isSuccess(), false);
      expect(projectUrl.exceptionOrNull(), isA<DioException>());
    });

    test(
        'Should returnt exception when the response is different than expected',
        () async {
      when(() => clientHttp.post(any()))
          .thenAnswer((_) async => Success(ClientResponse(
                data: {},
                statusCode: 200,
                request:
                    ClientRequest(path: '', data: {'projectName': 'project'}),
              )));

      final projectUrl = await generateRepository.createZip(Project());

      expect(projectUrl.isSuccess(), false);
      expect(projectUrl.exceptionOrNull(), isNotNull);
    });

    test(
        'Should returnt exception when the request does not have a project name',
        () async {
      when(() => clientHttp.post(any()))
          .thenAnswer((_) async => Success(ClientResponse(
                data: ResponseMock.postCreate,
                statusCode: 200,
                request: ClientRequest(path: '', data: {}),
              )));

      final projectUrl = await generateRepository.createZip(Project());

      expect(projectUrl.isSuccess(), false);
      expect(projectUrl.exceptionOrNull(), isNotNull);
    });
  });
}
