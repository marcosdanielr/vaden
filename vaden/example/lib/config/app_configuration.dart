import 'package:vaden/vaden.dart';
import 'package:vaden/vaden_openapi.dart';

@Configuration()
class AppConfiguration {
  @Bind()
  ApplicationSettings settings() {
    return ApplicationSettings.load('application.yaml');
  }

  @Bind()
  Storage configStorage(ApplicationSettings settings) {
    return Storage.createStorageService(settings);
  }

  @Bind()
  Pipeline globalMiddleware(ApplicationSettings settings) {
    return Pipeline() //
        .addMiddleware(logRequests());
  }

  @Bind()
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
