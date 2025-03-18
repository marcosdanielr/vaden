import 'dart:convert';

import 'package:vaden/vaden.dart';
import 'package:vaden/vaden_openapi.dart';

@Configuration()
class OpenApiConfiguration {
  @Bean()
  OpenApi openApi(OpenApiConfig config, ApplicationSettings settings) {
    return OpenApi(
      version: '3.0.0',
      info: Info(
        title: settings['openapi']['title'],
        version: settings['openapi']['version'],
        description: settings['openapi']['description'],
      ),
      servers: [
        if (settings['server']['mode'] == 'debug')
          config.localServer.copyWith(
            url: 'http://localhost:8080',
          ),
        if (settings['server']['mode'] == 'production')
          config.localServer.copyWith(
            url: 'https://api.vaden.dev',
            description: 'Vaden API Production',
          ),
      ],
      tags: config.tags,
      paths: config.paths,
      components: Components(
        schemas: config.schemas,
      ),
    );
  }

  @Bean()
  SwaggerUI swaggerUI(OpenApi openApi) {
    return SwaggerUI(
      jsonEncode(openApi.toJson()),
      title: 'Vaden API',
      docExpansion: DocExpansion.list,
      deepLink: true,
      persistAuthorization: false,
      syntaxHighlightTheme: SyntaxHighlightTheme.agate,
    );
  }
}
