import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/repositories/generate_repository.dart';
import 'package:frontend/data/repositories/remote_generate_repository.dart';
import 'package:frontend/data/services/client_http.dart';
import 'package:frontend/domain/dtos/dependency_dto.dart';
import 'package:frontend/domain/dtos/project_dto.dart';
import 'package:frontend/domain/dtos/project_link_dto.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../mock/response_mock.dart';

class MockClientHttp extends Mock implements ClientHttp {}

class MockcDioException extends Mock implements DioException {}

class ClientRequestFake extends Fake implements ClientRequest {}

void main() {
  late ClientHttp clientHttp;
  late GenerateRepository generateRepository;

  setUpAll(() {
    registerFallbackValue(ClientRequestFake());
  });

  setUp(() {
    clientHttp = MockClientHttp();
    generateRepository = RemoteGenerateRepository(clientHttp);
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
      expect(dependencies.getOrNull(), isA<List<DependencyDTO>>());
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
      when(() => clientHttp.post(any()))
          .thenAnswer((_) async => Success(ClientResponse(
                data: ResponseMock.postCreate,
                statusCode: 200,
                request:
                    ClientRequest(path: '', data: {'projectName': 'project'}),
              )));

      final projectUrl = await generateRepository.create(ProjectDto());

      expect(projectUrl.isSuccess(), true);
      expect(projectUrl.getOrNull(), isA<ProjectLinkDTO>());
      expect(
          projectUrl.getOrNull()?.url,
          equals('https://api.vaden.dev/resource/uploads/'
              '1a8ccfed-b200-4d57-83a6-99b65abafcf5.zip?name=project'));
    });

    test('Should returnt dio exception when the response is fail', () async {
      when(() => clientHttp.post(any()))
          .thenAnswer((_) async => Failure(MockcDioException()));

      final projectUrl = await generateRepository.create(ProjectDto());

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

      final projectUrl = await generateRepository.create(ProjectDto());

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

      final projectUrl = await generateRepository.create(ProjectDto());

      expect(projectUrl.isSuccess(), false);
      expect(projectUrl.exceptionOrNull(), isNotNull);
    });
  });
}
