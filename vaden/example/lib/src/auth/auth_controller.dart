import 'dart:convert';

import 'package:vaden/vaden.dart';

import 'auth_guard.dart';

@UseGuards([AuthGuard])
@Controller('/auth')
class AuthController {
  AuthController();

  @Post('/login')
  Future<Response> login(
    Request request,
  ) async {
    final body = jsonDecode(await request.readAsString()) as Map;

    return Response.ok({
      'message': 'Login successful',
      'data': body,
    }.toString());
  }
}
