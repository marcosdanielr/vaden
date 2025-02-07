import 'dart:async';

import 'package:vaden/vaden.dart';

@Controller('/auth')
class AuthController {
  @Post('/login')
  FutureOr<Response> login(Request request) {
    return Response.ok('ok!');
  }
}
