import 'dart:async';

import 'package:vaden/vaden.dart';

abstract class VadenMiddleware {
  FutureOr<Response> handler(Request request, Handler handler);

  Middleware toMiddleware() {
    return (h) {
      return (request) {
        return handler(request, h);
      };
    };
  }
}
