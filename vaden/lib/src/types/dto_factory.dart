typedef FromJsonFunction<T> = T Function(Map<String, dynamic> json);
typedef ToJsonFunction<T> = Map<String, dynamic> Function(T object);

/// added to openapi
typedef ToOpenApiFunction = Map<String, dynamic>;

abstract class DTOFactory {
  late final Map<Type, FromJsonFunction> _mapFromJson;
  late final Map<Type, ToJsonFunction> _mapToJson;
  //added to openapi
  late final Map<Type, ToOpenApiFunction> _mapToOpenApi;

  DTOFactory() {
    final maps = getMaps();
    _mapFromJson = maps.$1;
    _mapToJson = maps.$2;
    //added to openapi
    _mapToOpenApi = maps.$3;
  }

  (
    Map<Type, FromJsonFunction>,
    Map<Type, ToJsonFunction>,
    Map<Type, ToOpenApiFunction>,
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

  Map<String, dynamic>? toOpenApi<T>() {
    final toOpenApiFunction = _mapToOpenApi[T];
    if (toOpenApiFunction == null) {
      return null;
    }
    return toOpenApiFunction;
  }
}
