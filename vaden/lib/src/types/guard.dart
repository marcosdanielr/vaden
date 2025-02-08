import 'dart:async';

import 'package:vaden/vaden.dart';

abstract class Guard extends Middleware {
  FutureOr<bool> canActivate(Request request);

  @override
  FutureOr<Response> handle(Request request, Handler handler) async {
    final result = await canActivate(request);

    if (result) {
      return handler(request);
    }

    return Response.forbidden('Forbidden: $runtimeType');
  }
}
