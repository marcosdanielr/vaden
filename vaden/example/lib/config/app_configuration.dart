import 'package:vaden/vaden.dart';
import 'package:vaden/vaden_openapi.dart';

@Configuration()
class AppConfiguration {
  @Bean()
  ApplicationSettings settings() {
    return ApplicationSettings.load('application.yaml');
  }

  @Bean()
  Storage configStorage(ApplicationSettings settings) {
    return Storage.createStorageService(settings);
  }

  @Bean()
  Pipeline globalMiddleware(ApplicationSettings settings) {
    return Pipeline() //
        .addMiddleware(logRequests());
  }

  @Bean()
  OpenApi openApi(OpenApiConfig config) {
    return OpenApi(
      version: '3.0.0',
      info: Info(
        title: 'dsd',
        version: '1.0.0',
        description: 'Vaden Backend example',
      ),
      servers: [
        config.localServer,
      ],
      tags: config.tags,
      paths: config.paths,
      components: Components(
        schemas: config.schemas,
        securitySchemes: {
          // 'bearerAuth': SecurityScheme.http(
          //   scheme: HttpSecurityScheme.bearer,
          //   bearerFormat: 'JWT',
          //   description: 'Bearer authentication',
          // ),
        },
      ),
    );
  }
}
