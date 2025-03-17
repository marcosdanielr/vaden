import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:vaden/vaden.dart';

final exceptionHandlerChecker = TypeChecker.fromRuntime(ExceptionHandler);
final controllerAdviceChecker = TypeChecker.fromRuntime(ControllerAdvice);

String controllerAdviceSetup(ClassElement classElement) {
  final bodyBuffer = StringBuffer();

  final methods = classElement.methods.where((method) {
    return exceptionHandlerChecker.hasAnnotationOf(method);
  }).toList();

  if (methods.isEmpty) return '';

  final instanceName = 'controllerAdvice${classElement.name}';
  bodyBuffer.writeln('final $instanceName = _injector.get<${classElement.name}>();');

  for (final method in methods) {
    final exceptionHandler = exceptionHandlerChecker.firstAnnotationOf(method)!;
    final exceptionType = exceptionHandler.getField('exceptionType')!.toTypeValue()!;
    final exceptionTypeName = exceptionType.getDisplayString();

    final isFuture = method.returnType.isDartAsyncFuture || method.returnType.isDartAsyncFutureOr;
    bodyBuffer.writeln('''
if (e is $exceptionTypeName) {
  return ${isFuture ? 'await' : ''} $instanceName.${method.name}(e);
}
''');
  }

  return bodyBuffer.toString();
}
