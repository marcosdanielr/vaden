import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/repositories/generate_repository.dart';
import 'package:frontend/data/repositories/remote_generate_repository.dart';
import 'package:frontend/data/services/client_http.dart';
import 'package:frontend/domain/dtos/dependency_dto.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../mock/response_mock.dart';

class MockClientHttp extends Mock implements ClientHttp {}

class MockcDioException extends Mock implements DioException {}

void main() {
  late ClientHttp clientHttp;
  late GenerateRepository generateRepository;

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
              )));

      final dependencies = await generateRepository.getDependencies();

      expect(dependencies.isSuccess(), false);
      expect(dependencies.exceptionOrNull(), isNotNull);
    });
  });
}
