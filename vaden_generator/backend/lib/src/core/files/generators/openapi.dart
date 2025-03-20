import 'dart:io';

import 'package:backend/src/core/files/file_generate.dart';
import 'package:backend/src/core/files/file_manager.dart';

class OpenAPIGenerator extends FileGenerator {
  @override
  Future<void> generate(
    FileManager fileManager,
    Directory directory, {
    Map<String, dynamic> variables = const {},
  }) async {
    final libConfigOpenapiOpenapiConfiguration =
        File('${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}openapi${Platform.pathSeparator}openapi_configuration.dart');
    await libConfigOpenapiOpenapiConfiguration.create(recursive: true);
    await libConfigOpenapiOpenapiConfiguration.writeAsString(parseVariables(_libConfigOpenapiOpenapiConfigurationContent, variables));

    final libConfigOpenapiOpenapiController =
        File('${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}openapi${Platform.pathSeparator}openapi_controller.dart');
    await libConfigOpenapiOpenapiController.create(recursive: true);
    await libConfigOpenapiOpenapiController.writeAsString(_libConfigOpenapiOpenapiControllerContent);

    final helloController = File('${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}src${Platform.pathSeparator}hello_controller.dart');
    await fileManager.insertLineInFile(
      helloController,
      RegExp(r'@Controller\(.+\)'),
      "@Api(tag: 'Hello', description: 'Hello Controller')",
      position: InsertLinePosition.before,
    );
  }
}

const _libConfigOpenapiOpenapiConfigurationContent = '''import 'dart:convert';

import 'package:vaden/vaden.dart';
import 'package:vaden/vaden_openapi.dart';

@Configuration()
class OpenApiConfiguration {
  @Bean()
  OpenApi openApi(OpenApiConfig config) {
    return OpenApi(
      version: '3.0.0',
      info: Info(
        title: 'Vaden API',
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
      ),
    );
  }

  @Bean()
  SwaggerUI swaggerUI(OpenApi openApi) {
    return SwaggerUI(
      jsonEncode(openApi.toJson()),
      title: '{{name}} API',
      docExpansion: DocExpansion.list,
      deepLink: true,
      persistAuthorization: false,
      syntaxHighlightTheme: SyntaxHighlightTheme.agate,
    );
  }
}

''';

const _libConfigOpenapiOpenapiControllerContent = '''import 'dart:async';

import 'package:vaden/vaden.dart';
import 'package:vaden/vaden_openapi.dart' hide Response;

@Controller('/docs')
class OpenAPIController {
  final SwaggerUI swaggerUI;
  final ApplicationSettings settings;

  const OpenAPIController(this.swaggerUI, this.settings);

  @Get('/')
  FutureOr<Response> getSwagger(Request request) {
    if (settings['openapi']['enable'] == true) {
      return swaggerUI.call(request);
    }

    return Response.notFound('Not Found');
  }
}
''';
