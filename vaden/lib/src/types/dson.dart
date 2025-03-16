import 'package:vaden/src/types/response_exception.dart';

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

  T fromJson<T>(Map<String, dynamic> json) {
    final FromJsonFunction? fromJsonFunction = _mapFromJson[T];
    if (fromJsonFunction == null) {
      throw ResponseException(400, {'error': '$T is not a DTO'});
    }
    return fromJsonFunction(json);
  }

  List<T> fromJsonList<T>(List<Map<String, dynamic>> json) {
    return json.map((e) => fromJson<T>(e)!).toList();
  }

  Map<String, dynamic> toJson<T>(T object) {
    final ToJsonFunction<T>? toJsonFunction = _mapToJson[T];
    if (toJsonFunction == null) {
      throw ResponseException(400, {'error': '$T is not a DTO'});
    }
    return toJsonFunction(object);
  }

  List<Map<String, dynamic>> toJsonList<T>(List<T> object) {
    return object.map((e) => toJson<T>(e)).toList();
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
