typedef FromJsonFunction<T> = T Function(Map<String, dynamic> json);
typedef ToJsonFunction<T> = Map<String, dynamic> Function(T object);

/// added to openapi
typedef ToOpenApiNormalMap = Map<String, dynamic>;

abstract class DSON {
  late final Map<Type, FromJsonFunction> _mapFromJson;
  late final Map<Type, ToJsonFunction> _mapToJson;
  //added to openapi
  late final Map<Type, ToOpenApiNormalMap> _mapToOpenApi;

  DSON() {
    final maps = getMaps();
    _mapFromJson = maps.$1;
    _mapToJson = maps.$2;
    //added to openapi
    _mapToOpenApi = maps.$3;
  }

  (
    Map<Type, FromJsonFunction>,
    Map<Type, ToJsonFunction>,
    Map<Type, ToOpenApiNormalMap>,
  ) getMaps();

  T? fromJson<T>(Map<String, dynamic> json) {
    final FromJsonFunction? fromJsonFunction = _mapFromJson[T];
    if (fromJsonFunction == null) {
      return null;
    }
    return fromJsonFunction(json);
  }

  Map<String, dynamic>? toJson<T>(T object) {
    final ToJsonFunction<T>? toJsonFunction = _mapToJson[T];
    if (toJsonFunction == null) {
      return null;
    }
    return toJsonFunction(object);
  }

  List<Map<String, dynamic>> toJsonList<T>(List<T> object) {
    return object.map((e) => toJson<T>(e)!).toList();
  }

  Map<String, dynamic>? toOpenApi<T>() {
    final toOpenApiNormalMap = _mapToOpenApi[T];
    if (toOpenApiNormalMap == null) {
      return null;
    }
    return toOpenApiNormalMap;
  }

  Map<Type, ToOpenApiNormalMap> get apiEntries => _mapToOpenApi;
}
