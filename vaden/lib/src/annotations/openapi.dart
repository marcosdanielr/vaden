part of 'annotation.dart';

class Api {
  final List<String> tags;
  final String description;
  const Api({this.tags = const [], this.description = ''});
}

class ApiOperation {
  final String summary;
  final String description;
  const ApiOperation({required this.summary, this.description = ''});
}

class ApiResponse {
  final int statusCode;
  final String description;
  final ApiContent? content;
  const ApiResponse(this.statusCode, {this.description = '', this.content});
}

class ApiContent {
  final String type;
  final Type? schema;
  const ApiContent({
    required this.type,
    this.schema,
  });
}

class ApiParam {
  final String name;
  final String description;
  final bool required;
  const ApiParam({required this.name, this.description = '', this.required = false});
}
