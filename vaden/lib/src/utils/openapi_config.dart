import 'package:vaden/vaden.dart' hide Server, Response;
import 'package:vaden/vaden_openapi.dart';

class OpenApiConfig {
  final Map<String, dynamic> _paths;
  final Map<Type, ToOpenApiNormalMap> _components;
  final ApplicationSettings _settings;
  final List<Api> _apis;

  OpenApiConfig(
    this._paths,
    this._components,
    this._apis,
    this._settings,
  );

  static OpenApiConfig Function(DSON dson, ApplicationSettings settings) create(
    Map<String, dynamic> paths,
    List<Api> apis,
  ) {
    return (dson, settings) {
      return OpenApiConfig(
        paths,
        dson.apiEntries,
        apis,
        settings,
      );
    };
  }

  Server get localServer {
    return Server(
      url: 'http://${_settings['server']['host']}:${_settings['server']['port']}',
      description: 'Local server',
    );
  }

  List<Tag> get tags {
    return _apis.map((api) {
      return Tag(
        name: api.tag,
        description: api.description,
      );
    }).toList();
  }

  Map<String, PathItem> get paths {
    return _paths.map((key, value) {
      return MapEntry(key, PathItem.fromJson(value));
    });
  }

  Map<String, Schema> get schemas {
    return _components.map((key, value) {
      return MapEntry(key.toString(), Schema.fromJson(value));
    });
  }
}
