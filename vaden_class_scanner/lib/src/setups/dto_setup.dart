import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:vaden/vaden.dart';

final _jsonKeyChecker = TypeChecker.fromRuntime(JsonKey);
// final _jsonIgnoreChecker = TypeChecker.fromRuntime(JsonIgnore);

String dtoSetup(ClassElement classElement) {
  final bodyBuffer = StringBuffer();
  final fromJsonBody = _fromJson(classElement);
  final toJsonBody = _toJson(classElement);
  final toOpenApiBody = _toOpenApi(classElement);

  bodyBuffer.writeln('''
fromJsonMap[${classElement.name}] = (Map<String, dynamic> json) {
  return ${classElement.name}(
    $fromJsonBody
);
};''');

  bodyBuffer.writeln('''
toJsonMap[${classElement.name}] = (object) {
  final obj = object as ${classElement.name};
  return {
  $toJsonBody
  };
};''');

  bodyBuffer.writeln('toOpenApiMap[${classElement.name}] = $toOpenApiBody;');

  return bodyBuffer.toString();
}

String _toOpenApi(ClassElement classElement) {
  final propertiesBuffer = StringBuffer();
  final requiredFields = <String>[];

  final fields = classElement.fields.where((f) => !f.isStatic && !f.isPrivate);
  bool first = true;
  for (final field in fields) {
    final fieldName = _getFieldName(field);
    final schema = _fieldToSchema(field.type);
    if (!first) propertiesBuffer.writeln(',');
    propertiesBuffer.write('    "$fieldName": $schema');
    first = false;

    if (field.type.nullabilitySuffix == NullabilitySuffix.none) {
      requiredFields.add('"$fieldName"');
    }
  }

  final buffer = StringBuffer();
  buffer.writeln('{');
  buffer.writeln('  "type": "object",');
  buffer.writeln('  "properties": {');
  buffer.write(propertiesBuffer.toString());
  buffer.writeln();
  buffer.writeln('  },');
  buffer.writeln('  "required": [${requiredFields.join(', ')}]');
  buffer.writeln('}');
  return buffer.toString();
}

String _fieldToSchema(DartType type) {
  if (type.isDartCoreInt) {
    return '{"type": "integer"}';
  } else if (type.isDartCoreDouble) {
    return '{"type": "number"}';
  } else if (type.isDartCoreBool) {
    return '{"type": "boolean"}';
  } else if (type.isDartCoreString) {
    return '{"type": "string"}';
  } else if (type.isDartCoreList) {
    final elementType = (type as ParameterizedType).typeArguments.first;
    final elementSchema = _fieldToSchema(elementType);

    return '{"type": "array", "items": $elementSchema}';
  } else {
    final typeName = type.getDisplayString();
    return '{r"\$ref": "#/components/schemas/$typeName"}';
  }
}

String _fromJson(ClassElement classElement) {
  final construtorBuffer = StringBuffer();

  final constructor = classElement.constructors.firstWhere(
    (ctor) => !ctor.isFactory && ctor.isPublic,
  );

  for (final parameter in constructor.parameters) {
    final paramName = _getParameterName(parameter);
    final paramType = parameter.type.getDisplayString();
    final isNotNull = parameter.type.nullabilitySuffix == NullabilitySuffix.none;
    var paramValue = '';

    if (isPrimitiveListOrMap(parameter.type)) {
      paramValue = 'json[\'$paramName\']';
    } else {
      if (parameter.type.isDartCoreList) {
        final param = parameter.type as ParameterizedType;
        final arg = param.typeArguments.first;
        paramValue = isNotNull ? 'fromJsonList<$arg>(json[\'$paramName\'])' : 'json[\'$paramName\'] == null ? null : fromJsonList<$arg>(json[\'$paramName\'])';
      } else {
        paramValue = isNotNull ? 'fromJson<$paramType>(json[\'$paramName\'])' : 'json[\'$paramName\'] == null ? null : fromJson<$paramType>(json[\'$paramName\'])';
      }
    }

    if (parameter.isNamed) {
      construtorBuffer.writeln("    ${parameter.name}: $paramValue,");
    } else {
      construtorBuffer.writeln("    $paramValue,");
    }
  }

  return construtorBuffer.toString();
}

String _getParameterName(ParameterElement parameter) {
  if (parameter.isInitializingFormal) {
    final ctorParam = parameter as FieldFormalParameterElement;
    final fieldElement = ctorParam.field!;
    return _getFieldName(fieldElement);
  }

  return parameter.name;
}

String _getFieldName(FieldElement parameter) {
  if (_jsonKeyChecker.hasAnnotationOfExact(parameter)) {
    final annotation = _jsonKeyChecker.firstAnnotationOfExact(parameter);
    final name = annotation?.getField('name')?.toStringValue();
    if (name != null) {
      return name;
    }
  }

  return parameter.name;
}

String _toJson(ClassElement classElement) {
  final jsonBuffer = StringBuffer();
  for (final field in classElement.fields.where((f) => !f.isStatic && !f.isPrivate)) {
    jsonBuffer.writeln(_toJsonField(field));
  }

  return jsonBuffer.toString();
}

String _toJsonField(FieldElement field) {
  final fieldKey = _getFieldName(field);
  final fieldName = field.name;
  final fieldTypeString = field.type.getDisplayString();
  final isNotNull = field.type.nullabilitySuffix == NullabilitySuffix.none;

  if (isPrimitiveListOrMap(field.type)) {
    return "'$fieldKey': obj.$fieldName,";
  } else {
    if (field.type.isDartCoreList) {
      final param = field.type as ParameterizedType;
      final arg = param.typeArguments.first;
      return isNotNull ? " '$fieldKey': toJsonList<$arg>(obj.$fieldName)," : " '$fieldKey': obj.$fieldName == null ? null : toJsonList<$arg>(obj.$fieldName!),";
    } else {
      return isNotNull ? "'$fieldKey': toJson<$fieldTypeString>(obj.$fieldName)," : "'$fieldKey': obj.$fieldName == null ? null : toJson<$fieldTypeString>(obj.$fieldName!),";
    }
  }
}

bool isPrimitive(DartType type) {
  return type.isDartCoreInt || //
      type.isDartCoreDouble ||
      type.isDartCoreBool ||
      type.isDartCoreMap ||
      type.isDartCoreString;
}

bool isPrimitiveListOrMap(DartType type) {
  if (type.isDartCoreList) {
    final param = type as ParameterizedType;
    final arg = param.typeArguments.first;

    return isPrimitive(arg);
  }
  if (type.isDartCoreMap) {
    return true;
  }
  return isPrimitive(type);
}
