import 'package:vaden/vaden.dart';

import 'auth_configuration.dart';
import 'auth_guard.dart';
import 'auth_service.dart';
import 'credentials.dart';
import 'credentials_validator.dart';

@Controller('/auth')
class AuthController {
  final AuthService _authService;
  final MyEnv _myEnv;
  final CredentialsValidator _credentialsValidator;

  AuthController(this._authService, this._myEnv, this._credentialsValidator);

  @Get('/ping')
  Future<Response> ping() async {
    return Response.ok('${_authService.ping()} ${_myEnv.url}');
  }

  @UseGuards([AuthGuard])
  @Get('/other')
  Future<Response> other(@Query('id') String? id) async {
    return Response.ok('other $id');
  }

  @Post('/login')
  Future<Response> login(@Body() Credentials credentials) async {
    _credentialsValidator.validate(credentials);

    return Response.ok('login ${credentials.email}');
  }
}
