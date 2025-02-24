import 'dart:async';

import 'package:vaden/vaden.dart';
import 'package:vaden/vaden_openapi.dart' hide Response;

@Controller('/docs')
class OpenAPIController {
  final SwaggerUI swaggerUI;
  const OpenAPIController(this.swaggerUI);

  @Get('/')
  FutureOr<Response> getSwagger(Request request) {
    return swaggerUI.call(request);
  }
}
