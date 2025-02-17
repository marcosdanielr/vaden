import 'dart:convert';

import 'package:openapi_spec/openapi_spec.dart';
import 'package:test/test.dart';

void main() {
  test('open api test', () {
    final openApi = OpenApi(
      info: Info(
        title: 'Test API',
        version: '1.0.0',
      ),
      tags: [Tag(name: 'ping')],
      paths: <String, PathItem>{
        '/ping': PathItem(
          get: Operation(
            tags: ['ping'],
            security: [Security(name: 'bearerAuth')],
            parameters: [
              Parameter.path(
                name: 'id',
              ),
            ],
            requestBody: RequestBody(
              content: {
                'application/json': MediaType(
                  schema: Schema.object(
                    properties: {
                      'name': Schema.string(),
                    },
                  ),
                ),
              },
            ),
            responses: {
              '200': Response(
                description: 'login realizado com sucesso',
                content: {
                  'application/json': MediaType(
                    schema: Schema.object(
                      properties: {
                        'accessToken': Schema.string(),
                        'refreshToken': Schema.string(),
                        'expiresIn': Schema.integer(),
                      },
                    ),
                  ),
                },
              ),
            },
          ),
        ),
      },
      components: Components(
        securitySchemes: {
          'bearerAuth': SecurityScheme.http(
            scheme: HttpSecurityScheme.bearer,
            bearerFormat: 'JWT',
          ),
        },
      ),
    );

    print(jsonEncode(openApi.toJson()));
  });
}
