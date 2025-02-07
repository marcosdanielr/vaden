import 'dart:async';

import 'package:vaden/vaden.dart';

abstract class Guard {
  FutureOr<bool> canActivate(Request request);
}
