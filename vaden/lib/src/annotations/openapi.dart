part of 'annotation.dart';

class Api {
  final String tag;
  final String description;
  const Api({required this.tag, this.description = ''});
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
  final String? name;
  final String description;
  final bool required;
  const ApiParam({this.name, this.description = '', this.required = false});
}

class ApiQuery {
  final String? name;
  final String description;
  final bool required;
  const ApiQuery({this.name, this.description = '', this.required = false});
}

class ApiSecurity {
  final List<String> schemes;

  const ApiSecurity(this.schemes);
}
