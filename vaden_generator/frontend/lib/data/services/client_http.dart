import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

class ClientHttp {
  final Dio _dio;

  ClientHttp(this._dio);

  AsyncResult<ClientResponse> get(String path,
      {Map<String, String>? headers}) async {
    _dio.options.baseUrl = const String.fromEnvironment('BASE_URL');
    try {
      final response = await _dio.get(path, options: Options(headers: headers));
      return Success(ClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        message: response.statusMessage,
      ));
    } on DioException catch (e) {
      return Failure(ClientException.fromDioException(e));
    }
  }

  AsyncResult<ClientResponse> post(
    String path, {
    Map<String, String>? headers,
    dynamic data,
  }) async {
    _dio.options.baseUrl = const String.fromEnvironment('BASE_URL');
    try {
      final response = await _dio.post(
        path,
        options: Options(headers: headers),
        data: data,
      );
      return Success(ClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        message: response.statusMessage,
      ));
    } on DioException catch (e) {
      return Failure(ClientException.fromDioException(e));
    }
  }
}

class ClientResponse {
  dynamic data;
  int? statusCode;
  String? message;

  ClientResponse({this.data, this.statusCode, this.message});
}

class ClientException implements Exception {
  final String message;
  final dynamic data;
  final int? statusCode;
  final dynamic error;

  ClientException({
    required this.message,
    this.statusCode,
    this.data,
    required this.error,
  });

  factory ClientException.fromDioException(DioException dioException) =>
      ClientException(
        message: dioException.message ?? 'Client Http error',
        data: dioException.response?.data ?? {},
        statusCode: dioException.response?.statusCode,
        error: dioException.error,
      );
}
