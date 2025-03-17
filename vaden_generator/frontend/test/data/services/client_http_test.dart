import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/services/client_http.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockDioResponse<T> extends Mock implements Response<T> {}

void main() {
  late Dio dio;
  late ClientHttp clientHttp;
  late DioException dioError;
  late BaseOptions options;

  setUp(() {
    dio = MockDio();
    clientHttp = ClientHttp(dio);

    dioError = DioException(
      requestOptions: RequestOptions(path: '/test'),
      response: Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 500,
        data: {'error': 'Internal Server Error'},
      ),
      error: 'Some error',
    );

    options = BaseOptions(
      baseUrl: '',
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 5000),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Charset': 'utf-8',
      },
    );

    when(() => dio.options).thenReturn(options);
  });

  MockDioResponse mockDioResponse(
      {dynamic data, int? statusCode, String? statusMessage}) {
    final mockResponse = MockDioResponse();
    when(() => mockResponse.data).thenReturn(data ?? {'key': 'value'});
    when(() => mockResponse.statusCode).thenReturn(statusCode ?? 200);
    when(() => mockResponse.statusMessage).thenReturn(statusMessage ?? 'OK');
    return mockResponse;
  }

  group('ClientHttp - GET', () {
    test('Should return ClientResponse on successful GET request', () async {
      when(() => dio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => mockDioResponse());

      final result = await clientHttp.get('/test');

      expect(result.isSuccess(), true);
      expect(result.getOrNull()!.statusCode, 200);
    });

    test('Should return ClientException on GET request failure', () async {
      when(() => dio.get(any(), options: any(named: 'options')))
          .thenThrow(dioError);

      final result = await clientHttp.get('/test');

      expect(result.isError(), true);
      expect(result.exceptionOrNull(), isA<ClientException>());
    });
  });

  group('ClientHttp - POST', () {
    test('Should return ClientResponse on successful POST request', () async {
      when(() => dio.post(any(),
              options: any(named: 'options'), data: any(named: 'data')))
          .thenAnswer((_) async => mockDioResponse(statusCode: 201));

      final result = await clientHttp.post('/test', data: {'name': 'John'});

      expect(result.isSuccess(), true);
      expect(result.getOrNull()!.statusCode, 201);
    });

    test('Should return ClientException on POST request failure', () async {
      when(() => dio.post(any(),
          options: any(named: 'options'),
          data: any(named: 'data'))).thenThrow(dioError);

      final result = await clientHttp.post('/test', data: {'name': 'John'});

      expect(result.isError(), isTrue);
      expect(result.exceptionOrNull(), isA<ClientException>());
    });
  });
}
