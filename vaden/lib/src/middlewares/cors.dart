import 'package:shelf/shelf.dart';

Middleware cors({
  List<String> allowedOrigins = const ['*'],
  List<String> allowMethods = const ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  List<String> allowHeaders = const ['Origin', 'Content-Type', 'Accept'],
}) {
  return (Handler innerHandler) {
    return (Request request) async {
      final requestOrigin = request.headers['Origin'];

      String? allowOriginHeader;
      if (allowedOrigins.contains('*')) {
        allowOriginHeader = '*';
      } else if (requestOrigin != null && allowedOrigins.contains(requestOrigin)) {
        allowOriginHeader = requestOrigin;
      }

      if (request.method.toUpperCase() == 'OPTIONS') {
        var headers = <String, String>{
          if (allowOriginHeader != null) 'Access-Control-Allow-Origin': allowOriginHeader,
          'Access-Control-Allow-Methods': allowMethods.join(', '),
          'Access-Control-Allow-Headers': allowHeaders.join(', '),
        };
        return Response.ok('', headers: headers);
      }

      final response = await innerHandler(request);

      var headers = <String, String>{
        if (allowOriginHeader != null) 'Access-Control-Allow-Origin': allowOriginHeader,
        'Access-Control-Allow-Methods': allowMethods.join(', '),
        'Access-Control-Allow-Headers': allowHeaders.join(', '),
      };
      return response.change(headers: headers);
    };
  };
}
