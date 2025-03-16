// GENERATED CODE - DO NOT MODIFY BY HAND
// Aggregated Vaden application file
// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:convert';
import 'dart:io';
import 'package:vaden/vaden.dart';

import 'package:backend/config/resources/resource_controller.dart';
import 'package:backend/config/resources/resource_configuration.dart';
import 'package:backend/config/openapi/openapi_configuration.dart';
import 'package:backend/config/openapi/openapi_controller.dart';
import 'package:backend/config/app_configuration.dart';
import 'package:backend/src/core/files/file_manager.dart';
import 'package:backend/src/controllers/generate_controller.dart';
import 'package:backend/src/data/repositories/dependency_repository_impl.dart';
import 'package:backend/src/data/services/generate_service_impl.dart';
import 'package:backend/src/domain/dtos/project_link_dto.dart';
import 'package:backend/src/domain/dtos/dependency_dto.dart';
import 'package:backend/src/domain/dtos/project_dto.dart';
import 'package:backend/src/domain/usecases/get_dependencies.dart';
import 'package:backend/src/domain/usecases/create_project.dart';

class VadenApplication {
  final _router = Router();
  final _injector = AutoInjector();
  Injector get injector => _injector;

  VadenApplication();

  Future<HttpServer> run() async {
    final pipeline = _injector.get<Pipeline>();
    final handler = pipeline.addHandler((request) async {
      try {
        final response = await _router(request);
        return response;
      } catch (e, stack) {
        print(e);
        print(stack);
        return _handleException(e);
      }
    });

    final settings = _injector.get<ApplicationSettings>();
    final port = settings['server']['port'] ?? 8080;
    final host = settings['server']['host'] ?? '0.0.0.0';

    final server = await serve(handler, host, port);

    return server;
  }

  Future<void> setup() async {
    final paths = <String, dynamic>{};
    final apis = <Api>[];
    final asyncBeans = <Future<void> Function()>[];
    _injector.addLazySingleton<DSON>(_DSON.new);
    _injector.addLazySingleton(ResourceController.new);
    final routerResourceController = Router();
    var pipelineResourceControllergetResources = const Pipeline();
    final handlerResourceControllergetResources = (Request request) async {
      final ctrl = _injector.get<ResourceController>();
      final result = await ctrl.getResources(request);
      return result;
    };
    routerResourceController.mount(
      '/public',
      pipelineResourceControllergetResources.addHandler(
        handlerResourceControllergetResources,
      ),
    );
    var pipelineResourceControllergetUploads = const Pipeline();
    final handlerResourceControllergetUploads = (Request request) async {
      if (request.params['path'] == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid parameter (path)'}),
        );
      }
      final path = request.params['path']!;

      final filename = request.url.queryParameters['filename'];
      final ctrl = _injector.get<ResourceController>();
      final result = await ctrl.getUploads(request, path, filename);
      return result;
    };
    routerResourceController.get(
      '/uploads/<filename>',
      pipelineResourceControllergetUploads.addHandler(
        handlerResourceControllergetUploads,
      ),
    );
    _router.mount('/resource', routerResourceController.call);

    final configurationResourceConfiguration = ResourceConfiguration();

    _injector.addLazySingleton(
      configurationResourceConfiguration.configStorage,
    );
    _injector.addLazySingleton(configurationResourceConfiguration.resources);

    final configurationOpenApiConfiguration = OpenApiConfiguration();

    _injector.addLazySingleton(configurationOpenApiConfiguration.openApi);
    _injector.addLazySingleton(configurationOpenApiConfiguration.swaggerUI);

    _injector.addLazySingleton(OpenAPIController.new);
    final routerOpenAPIController = Router();
    var pipelineOpenAPIControllergetSwagger = const Pipeline();
    final handlerOpenAPIControllergetSwagger = (Request request) async {
      final ctrl = _injector.get<OpenAPIController>();
      final result = await ctrl.getSwagger(request);
      return result;
    };
    routerOpenAPIController.get(
      '/',
      pipelineOpenAPIControllergetSwagger.addHandler(
        handlerOpenAPIControllergetSwagger,
      ),
    );
    _router.mount('/docs', routerOpenAPIController.call);

    final configurationAppConfiguration = AppConfiguration();

    _injector.addLazySingleton(configurationAppConfiguration.settings);
    _injector.addLazySingleton(configurationAppConfiguration.globalMiddleware);

    _injector.addLazySingleton(FileManager.new);

    _injector.addLazySingleton(GenerateController.new);
    apis.add(const Api(tag: 'Generate', description: 'Generate a new project'));
    final routerGenerateController = Router();
    paths['/v1/generate/dependencies'] = {
      'get': {
        'tags': ['Generate'],
        'summary': '',
        'description': '',
        'responses': <String, dynamic>{},
        'parameters': <Map<String, dynamic>>[],
        'security': <Map<String, dynamic>>[],
      },
    };

    paths['/v1/generate/dependencies']['get']['summary'] = 'Get dependencies';
    paths['/v1/generate/dependencies']['get']['description'] =
        'Get all dependencies';
    paths['/v1/generate/dependencies']['get']['responses']['200'] = {
      'description': 'Dependencies returned',
      'content': <String, dynamic>{},
    };

    paths['/v1/generate/dependencies']['get']['responses']['200']['content']['application/json'] =
        <String, dynamic>{};

    paths['/v1/generate/dependencies']['get']['responses']['200']['content']['application/json']['schema'] =
        {
          'type': 'array',
          'items': {'\$ref': '#/components/schemas/DependencyDTO'},
        };

    var pipelineGenerateControllergetDependencies = const Pipeline();
    final handlerGenerateControllergetDependencies = (Request request) async {
      final ctrl = _injector.get<GenerateController>();
      try {
        final result = await ctrl.getDependencies();
        final json = _injector.get<DSON>().toJsonList<DependencyDTO>(result);
        return Response.ok(
          jsonEncode(json),
          headers: {'Content-Type': 'application/json'},
        );
      } on ResponseException catch (e) {
        return e.generateResponse(_injector.get<DSON>());
      } catch (e) {
        return Response(
          500,
          body: jsonEncode({'error': 'Internal server error'}),
        );
      }
    };
    routerGenerateController.get(
      '/dependencies',
      pipelineGenerateControllergetDependencies.addHandler(
        handlerGenerateControllergetDependencies,
      ),
    );
    paths['/v1/generate/create'] = {
      'get': {
        'tags': ['Generate'],
        'summary': '',
        'description': '',
        'responses': <String, dynamic>{},
        'parameters': <Map<String, dynamic>>[],
        'security': <Map<String, dynamic>>[],
      },
    };

    paths['/v1/generate/create']['get']['summary'] = 'Create project';
    paths['/v1/generate/create']['get']['description'] = 'Create a new project';
    paths['/v1/generate/create']['get']['responses']['200'] = {
      'description': 'Return Link to download zip project',
      'content': <String, dynamic>{},
    };

    paths['/v1/generate/create']['get']['responses']['200']['content']['application/json'] =
        <String, dynamic>{};

    paths['/v1/generate/create']['get']['responses']['200']['content']['application/json']['schema'] =
        {'\$ref': '#/components/schemas/ProjectLinkDTO'};

    var pipelineGenerateControllercreate = const Pipeline();
    paths['/v1/generate/create']['get']['requestBody'] = {
      'content': {
        'application/json': {
          'schema': {'\$ref': '#/components/schemas/ProjectDTO'},
        },
      },
      'required': true,
    };

    final handlerGenerateControllercreate = (Request request) async {
      final bodyString = await request.readAsString();
      final json = jsonDecode(bodyString) as Map<String, dynamic>;
      final dto = _injector.get<DSON>().fromJson<ProjectDTO>(json) as dynamic;

      if (dto == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid body: (ProjectDTO)'}),
        );
      }

      if (dto is Validator<ProjectDTO>) {
        final validator = dto.validate(ValidatorBuilder<ProjectDTO>());
        final resultValidator = validator.validate(dto as ProjectDTO);
        if (!resultValidator.isValid) {
          return Response(
            400,
            body: jsonEncode(resultValidator.exceptionToJson()),
          );
        }
      }

      final ctrl = _injector.get<GenerateController>();
      try {
        final result = await ctrl.create(dto);
        final json = _injector.get<DSON>().toJson<ProjectLinkDTO>(result);
        return Response.ok(
          jsonEncode(json),
          headers: {'Content-Type': 'application/json'},
        );
      } on ResponseException catch (e) {
        return e.generateResponse(_injector.get<DSON>());
      } catch (e) {
        return Response(
          500,
          body: jsonEncode({'error': 'Internal server error'}),
        );
      }
    };
    routerGenerateController.get(
      '/create',
      pipelineGenerateControllercreate.addHandler(
        handlerGenerateControllercreate,
      ),
    );
    _router.mount('/v1/generate', routerGenerateController.call);

    _injector.addBind(
      Bind.withClassName(
        constructor: DependencyRepositoryImpl.new,
        type: BindType.lazySingleton,
        className: 'DependencyRepository',
      ),
    );

    _injector.addBind(
      Bind.withClassName(
        constructor: GenerateServiceImpl.new,
        type: BindType.lazySingleton,
        className: 'GenerateService',
      ),
    );

    _injector.addLazySingleton(GetDependencies.new);

    _injector.addLazySingleton(CreateProject.new);

    _injector.addLazySingleton(OpenApiConfig.create(paths, apis).call);
    _injector.commit();

    for (final asyncBean in asyncBeans) {
      await asyncBean();
    }
  }
}

class _DSON extends DSON {
  @override
  (
    Map<Type, FromJsonFunction>,
    Map<Type, ToJsonFunction>,
    Map<Type, ToOpenApiNormalMap>,
  )
  getMaps() {
    final fromJsonMap = <Type, FromJsonFunction>{};
    final toJsonMap = <Type, ToJsonFunction>{};
    final toOpenApiMap = <Type, ToOpenApiNormalMap>{};

    fromJsonMap[ProjectLinkDTO] = (Map<String, dynamic> json) {
      return ProjectLinkDTO(json['url']);
    };
    toJsonMap[ProjectLinkDTO] = (object) {
      final obj = object as ProjectLinkDTO;
      return {'url': obj.url};
    };
    toOpenApiMap[ProjectLinkDTO] = {
      "type": "object",
      "properties": {
        "url": {"type": "string"},
      },
      "required": ["url"],
    };

    fromJsonMap[DependencyDTO] = (Map<String, dynamic> json) {
      return DependencyDTO(
        name: json['name'],
        version: json['version'],
        tag: json['tag'],
      );
    };
    toJsonMap[DependencyDTO] = (object) {
      final obj = object as DependencyDTO;
      return {'name': obj.name, 'version': obj.version, 'tag': obj.tag};
    };
    toOpenApiMap[DependencyDTO] = {
      "type": "object",
      "properties": {
        "name": {"type": "string"},
        "version": {"type": "string"},
        "tag": {"type": "string"},
      },
      "required": ["name", "version", "tag"],
    };

    fromJsonMap[ProjectDTO] = (Map<String, dynamic> json) {
      return ProjectDTO(
        dependencies: fromJsonList<DependencyDTO>(json['dependencies']),
        projectName: json['projectName'],
        projectDescription: json['projectDescription'],
        dartVersion: json['dartVersion'],
      );
    };
    toJsonMap[ProjectDTO] = (object) {
      final obj = object as ProjectDTO;
      return {
        'dependencies': toJsonList<DependencyDTO>(obj.dependencies),
        'projectName': obj.projectName,
        'projectDescription': obj.projectDescription,
        'dartVersion': obj.dartVersion,
      };
    };
    toOpenApiMap[ProjectDTO] = {
      "type": "object",
      "properties": {
        "dependencies": {r"$ref": "#/components/schemas/List<DependencyDTO>"},
        "projectName": {"type": "string"},
        "projectDescription": {"type": "string"},
        "dartVersion": {"type": "string"},
      },
      "required": [
        "dependencies",
        "projectName",
        "projectDescription",
        "dartVersion",
      ],
    };

    return (fromJsonMap, toJsonMap, toOpenApiMap);
  }
}

Response _handleException(dynamic e) {
  return Response.internalServerError(
    body: jsonEncode({'error': 'Internal server error'}),
  );
}
