import 'dart:async';

import 'package:vaden/vaden.dart';

abstract class Middleware {
  FutureOr<Response> handle(Request request, Handler handler);
}
