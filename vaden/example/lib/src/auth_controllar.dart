import 'package:vaden/vaden.dart';

import 'auth_guard.dart';
import 'auth_service.dart';
import 'credentials.dart';

@Controller('/auth')
class AuthControllar {
  final AuthService _authService;

  AuthControllar(this._authService);

  @UseGuards([AuthGuard])
  @Get('/ping')
  Future<Response> ping() async {
    return Response.ok(_authService.ping());
  }

  @Get('/other/<id>')
  Future<Response> other(@Param('id') String id) async {
    return Response.ok('other $id');
  }

  @Post('/login')
  Future<Response> login(@Body() Credentials credentials) async {
    return Response.ok('login ${credentials.username}');
  }
}
