import 'package:dio/dio.dart';
import 'package:frontend/config/constants.dart';
import 'package:result_dart/result_dart.dart';

Dio dioFactory(Constants constants) {
  return Dio(BaseOptions(baseUrl: constants.urlBase));
}

class ClientHttp {
  final Dio _dio;

  ClientHttp(this._dio);

  AsyncResult<ClientResponse> get(ClientRequest request) async {
    try {
      final response =
          await _dio.get(request.path, options: Options(headers: request.data));
      return Success(ClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        message: response.statusMessage,
        request: request,
      ));
    } on DioException catch (e) {
      return Failure(ClientException.fromDioException(e));
    }
  }

  AsyncResult<ClientResponse> post(ClientRequest request) async {
    try {
      final response = await _dio.post(
        request.path,
        options: Options(headers: request.headers),
        data: request.data,
      );
      return Success(ClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        message: response.statusMessage,
        request: request,
      ));
    } on DioException catch (e) {
      return Failure(ClientException.fromDioException(e));
    }
  }
}

class ClientRequest {
  final String path;
  final dynamic data;
  final Map<String, dynamic>? headers;

  ClientRequest({required this.path, this.data, this.headers});
}

class ClientResponse {
  final dynamic data;
  final int? statusCode;
  final String? message;
  final ClientRequest request;
  ClientResponse(
      {this.data, this.statusCode, this.message, required this.request});
}

class ClientException implements Exception {
  final String message;
  final dynamic data;
  final int? statusCode;
  final dynamic error;
  final ClientRequest request;
  ClientException({
    required this.message,
    this.statusCode,
    this.data,
    required this.error,
    required this.request,
  });

  factory ClientException.fromDioException(DioException dioException) =>
      ClientException(
          message: dioException.message ?? 'Client Http error',
          data: dioException.response?.data ?? {},
          statusCode: dioException.response?.statusCode,
          error: dioException.error,
          request: ClientRequest(
            path: dioException.requestOptions.path,
            data: dioException.requestOptions.data,
            headers: dioException.requestOptions.headers,
          ));
}
