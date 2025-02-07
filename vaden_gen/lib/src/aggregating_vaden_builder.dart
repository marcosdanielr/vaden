import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

import 'app_application_generator.dart';

/// Esse builder será executado uma vez por package e gerará um único
/// arquivo "lib/app_application.g.dart"
class AggregatingVadenBuilder implements Builder {
  @override
  final Map<String, List<String>> buildExtensions = const {
    r'$package$': ['lib/vaden_application.dart']
  };

  static AssetId _allFileOutput(BuildStep buildStep) {
    return AssetId(
      buildStep.inputId.package,
      p.join('lib', 'vaden_application.dart'),
    );
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    log.info('Procurando assets em lib/');
    final aggregatedBuffer = StringBuffer();
    final importsBuffer = StringBuffer();
    importsBuffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    importsBuffer.writeln('// Aggregated Vaden application file');
    importsBuffer.writeln();
    importsBuffer.writeln("import 'package:vaden/vaden.dart';");
    importsBuffer.writeln();

    aggregatedBuffer.writeln('abstract class VadenApplication {');
    aggregatedBuffer.writeln();
    aggregatedBuffer.writeln('  static Future<Response> run(Request request) async {');
    aggregatedBuffer.writeln('    final router = Router();');
    aggregatedBuffer.writeln('    final injector = AutoInjector();');
    aggregatedBuffer.writeln();

    // Define um glob para encontrar todos os arquivos Dart em lib/
    final dartFiles = await buildStep.findAssets(Glob('lib/**/*.dart')).toList();

    log.info('TOTAL: ${dartFiles.length}');

    // Cria uma instância do seu generator que processa Controllers (por exemplo, VadenGenerator)
    final generator = VadenGenerator();

    // Para cada arquivo Dart encontrado, tente obter a library e gerar código (se houver anotações relevantes)
    for (final assetId in dartFiles) {
      try {
        log.info(assetId.uri.toString());
        final library = await buildStep.resolver.libraryFor(assetId);
        final generated = await generator.generate(LibraryReader(library), buildStep);
        if (generated.trim().isNotEmpty) {
          importsBuffer.writeln("import '${assetId.uri.toString()}';");
          aggregatedBuffer.writeln(generated);
        }
      } catch (e) {
        log.severe('Erro processando $assetId: $e');
      }
    }

    aggregatedBuffer.writeln('    injector.commit();');
    aggregatedBuffer.writeln('    return router(request);');
    aggregatedBuffer.writeln('  }');

    aggregatedBuffer.writeln('}');

    importsBuffer.writeln();
    importsBuffer.writeln(aggregatedBuffer.toString());

    // Escreve o arquivo final no output
    final outputId = _allFileOutput(buildStep);
    await buildStep.writeAsString(outputId, importsBuffer.toString());
  }
}

Builder aggregatingVadenBuilder(BuilderOptions options) => AggregatingVadenBuilder();
