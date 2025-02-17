import 'package:vaden/vaden.dart';

import 'auth_guard.dart';
import 'auth_service.dart';
import 'credentials.dart';
import 'tokenization.dart';

@Api(tags: ['auth'], description: 'Auth API')
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

  @ApiOperation(summary: 'Faz login de usuário', description: 'Valida as credenciais e retorna um token de sessão')
  @ApiResponse(
    200,
    description: 'Usuário autenticado com sucesso',
    content: ApiContent(type: 'application/json', schema: Tokenization),
  )
  @ApiResponse(401, description: 'Credenciais inválidas')
  @Post('/login')
  Future<Response> login(
    @ApiParam(name: 'credentials', description: 'email and password ', required: true) //
    @Body()
    Credentials credentials,
  ) async {
    return Response.ok('login ${credentials.username}');
  }
}
