import 'dart:convert';

import 'package:example/src/auth_middleware.dart';
import 'package:example/src/auth_service.dart';
import 'package:vaden/vaden.dart';

import 'auth_guard.dart';
import 'credentials.dart';
import 'tokenization.dart';

@Api(tag: 'auth', description: 'Auth API')
@Controller('/auth')
class AuthController {
  final AuthService _authService;

  AuthController(this._authService);

  @UseGuards([AuthGuard])
  @Get('/ping')
  Future<Response> ping() async {
    return Response.ok(jsonEncode({"message": _authService.ping()}));
  }

  @ApiSecurity(['bearer'])
  @Get('/other/<id>')
  Future<Response> other(@Param('id') String id) async {
    return Response.ok(jsonEncode({"message": 'other $id'}));
  }

  @ApiOperation(
    summary: 'Faz login de usuário',
    description: 'Valida as credenciais e retorna um token de sessão',
  )
  @ApiResponse(
    200,
    description: 'Usuário autenticado com sucesso',
    content: ApiContent(type: 'application/json', schema: Tokenization),
  )
  @ApiResponse(401, description: 'Credenciais inválidas')
  @Post('/login')
  Tokenization login(
    @Body() Credentials credentials,
  ) {
    return Tokenization('fdsfsfsfsfsgdfrtr', 'fsdfrgbsbsfa');
  }

  @UseMiddleware([AuthMiddleware])
  @Post('/sign-out')
  Future<Response> signOut(@Context('user_id') String userId) async {
    return Response.ok('Deslogando do usuário $userId!');
  }

  @Post('/refresh-token')
  Future<Response> refreshToken(@Header('Authorization') String? token) async {
    if (token == null) {
      return Response.unauthorized('Token not found');
    }

    return Response.ok(
        'Token recuperado do header: ${token.replaceFirst('Bearer ', '')}');
  }
}
