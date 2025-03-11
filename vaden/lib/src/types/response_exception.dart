import 'package:shelf/shelf.dart';

class ResponseException implements Exception {
  final String message;
  final int code;

  const ResponseException(this.message, this.code);

  Response get response {
    return Response(code, body: message);
  }

  @override
  String toString() {
    return 'ResponseException{message: $message, code: $code}';
  }
}
