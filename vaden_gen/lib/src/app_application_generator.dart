import 'dart:async';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
// ignore: unused_import
import 'package:vaden/vaden.dart'; // O package vaden define as anotações

/// Generator que varre as classes anotadas com @Controller
/// e gera funções de registro de rotas para o Shelf.
class VadenGenerator extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    final buffer = StringBuffer();

    final componentChecker = TypeChecker.fromRuntime(Component);

    log.info('Generating routes for ${library.classes}');

    final components = library //
        .classes
        .where((classElement) {
      return classElement.metadata.any((meta) {
        final obj = meta.computeConstantValue();
        if (obj == null) return false;
        return componentChecker.isAssignableFromType(obj.type!);
      });
    }).toList();

    // Percorre todas as classes da library.
    for (var classElement in components) {
      log.info(classElement.name);

      final className = classElement.name;

      // Gera uma função de registro para esse controller.
      buffer.write('''
      injector.add($className.new);

      final router$className = Router();
      router$className.get('/', (Request request) async {
        final controller = injector.get<$className>();
        return controller.index(request);
      });

      router.mount('/$className', router$className);
''');
    }

    return buffer.toString();
  }
}

/// Factory para o builder
Builder vadenApplicationBuilder(BuilderOptions options) => LibraryBuilder(
      VadenGenerator(),
      generatedExtension: '.vaden.g.dart',
    );
