import 'dart:async';

import 'package:vaden/vaden.dart';

import 'auth_guard.dart';
import 'auth_service.dart';

@Controller('/auth')
class AuthController {
  final AuthService service;

  AuthController(this.service);

  @UseGuards([AuthGuard])
  @Get('/ping')
  FutureOr<Response> ping() {
    return Response.ok(service.pong());
  }

  @Get('/other')
  FutureOr<Response> other(@Query('id') String? id) {
    return Response.ok('other $id');
  }
}
