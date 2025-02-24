import 'dart:async';

import 'package:vaden/vaden.dart';

class EnforceJsonContentType extends VadenMiddleware {
  @override
  FutureOr<Response> handler(Request request, Handler handler) async {
    final response = await handler(request);

    if (!response.headers.containsKey('content-type')) {
      return response.change(headers: {
        ...response.headers,
        'content-type': 'application/json',
      });
    }
    return response;
  }
}
