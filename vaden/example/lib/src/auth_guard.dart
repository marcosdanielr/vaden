import 'dart:async';

import 'package:vaden/vaden.dart';

@Component()
class AuthGuard extends VadenGuard {
  @override
  FutureOr<bool> canActivate(Request request) {
    return true;
  }
}
