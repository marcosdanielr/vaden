import 'dart:async';

import 'package:vaden/vaden.dart';

import 'repository_example.dart';

@useGuard(GuardJwt)
@Controller('/examples')
class ControllerExamples {
  final ServiceExample serviceExample;

  ControllerExamples(this.serviceExample);

  @Get('/hello')
  FutureOr<Response> hello() {
    return Response.ok('Hello, World!');
  }

  @useGuard(GuardJwt)
  @Get('/goodbye') // /goodbye?username=foo&password=bar
  FutureOr<Response> goodbye(
    @Query('username') String username,
    @Query('password') String password,
  ) {
    return Response.ok(username);
  }

  @Get('/orange/:id')
  FutureOr<Response> orange(@Param('id') String id) {
    return Response.ok(id);
  }
}
