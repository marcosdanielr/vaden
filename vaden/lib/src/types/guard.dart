import 'dart:async';

import 'package:vaden/vaden.dart';

abstract class VadenGuard extends VadenMiddleware {
  FutureOr<bool> canActivate(Request request);

  @override
  FutureOr<Response> handler(Request request, Handler handler) async {
    final result = await canActivate(request);

    if (result) {
      return handler(request);
    }

    return Response.forbidden('Forbidden: $runtimeType');
  }
}
