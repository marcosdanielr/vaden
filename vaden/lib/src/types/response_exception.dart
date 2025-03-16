import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:vaden/src/types/dson.dart';

class ResponseException<W> implements Exception {
  final W body;
  final int code;
  final Map<String, String> headers;

  const ResponseException(this.code, this.body, {this.headers = const {}});

  Response generateResponse(DSON dson) {
    if (body is String) {
      return Response(code, body: body, headers: _enforceContentType(headers, 'text/plain'));
    } else if (body is List<int>) {
      return Response(code, body: body, headers: _enforceContentType(headers, 'application/octet-stream'));
    } else if (body is Map<String, dynamic>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else if (body is Map<String, Object>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else if (body is Map<String, String>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else if (body is List<Map<String, dynamic>>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else if (body is List<Map<String, String>>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else if (body is List<Map<String, Object>>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else {
      if (body is List) {
        final json = (body as List).map((e) => dson.toJson(e)).toList();
        return Response(code, body: jsonEncode(json), headers: _enforceContentType(headers, 'application/json'));
      }
      return Response(code, body: jsonEncode(dson.toJson(body)), headers: _enforceContentType(headers, 'application/json'));
    }
  }

  Map<String, String> _enforceContentType(Map<String, String> headers, String contentType) {
    final Map<String, String> enforcedHeaders = Map<String, String>.from(headers);

    if (enforcedHeaders['content-type'] == null && enforcedHeaders['Content-Type'] == null) {
      enforcedHeaders['Content-Type'] = contentType;
    }

    return enforcedHeaders;
  }

  @override
  String toString() {
    return 'ResponseException{message: $body, code: $code}';
  }
}
