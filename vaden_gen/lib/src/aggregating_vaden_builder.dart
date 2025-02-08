import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';
import 'package:vaden/vaden.dart';

class AggregatingVadenBuilder implements Builder {
  @override
  final Map<String, List<String>> buildExtensions = const {
    r'$package$': ['lib/vaden_application.dart']
  };

  AssetId _allFileOutput(BuildStep buildStep) {
    return AssetId(
      buildStep.inputId.package,
      p.join('lib', 'vaden_application.dart'),
    );
  }

  final formatter = DartFormatter(languageVersion: DartFormatter.latestLanguageVersion);

  final componentChecker = TypeChecker.fromRuntime(Component);
  final controllerChecker = TypeChecker.fromRuntime(Controller);
  final configurationChecker = TypeChecker.fromRuntime(Configuration);
  final bindChecker = TypeChecker.fromRuntime(Bind);

  final methodCheckers = <(TypeChecker, String)>[
    (TypeChecker.fromRuntime(Get), 'get'),
    (TypeChecker.fromRuntime(Post), 'post'),
    (TypeChecker.fromRuntime(Put), 'put'),
    (TypeChecker.fromRuntime(Patch), 'patch'),
    (TypeChecker.fromRuntime(Delete), 'delete'),
    (TypeChecker.fromRuntime(Head), 'head'),
    (TypeChecker.fromRuntime(Options), 'options'),
  ];

  final useGuardsChecker = TypeChecker.fromRuntime(UseGuards);
  final useMiddlewareChecker = TypeChecker.fromRuntime(UseMiddleware);

  final paramChecker = TypeChecker.fromRuntime(Param);
  final queryChecker = TypeChecker.fromRuntime(Query);

  @override
  Future<void> build(BuildStep buildStep) async {
    final aggregatedBuffer = StringBuffer();
    final importsBuffer = StringBuffer();

    final importSet = <String>{};

    importsBuffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    importsBuffer.writeln('// Aggregated Vaden application file');
    importsBuffer.writeln();
    importsBuffer.writeln("import 'package:vaden/vaden.dart';");
    importsBuffer.writeln();

    aggregatedBuffer.writeln('class VadenApplication {');
    aggregatedBuffer.writeln();
    aggregatedBuffer.writeln('  var _router = Router();');
    aggregatedBuffer.writeln('  var _injector = AutoInjector();');
    aggregatedBuffer.writeln();
    aggregatedBuffer.writeln('  VadenApplication();');
    aggregatedBuffer.writeln();
    aggregatedBuffer.writeln('  void _dispose(dynamic instance) {');
    aggregatedBuffer.writeln('    if (instance is Disposable) {');
    aggregatedBuffer.writeln('      instance.dispose();');
    aggregatedBuffer.writeln('    }');
    aggregatedBuffer.writeln('  }');
    aggregatedBuffer.writeln();
    aggregatedBuffer.writeln('  Future<Response> run(Request request) async {');
    aggregatedBuffer.writeln('    return _router(request);');
    aggregatedBuffer.writeln('  }');
    aggregatedBuffer.writeln();
    aggregatedBuffer.writeln('  Future<void> setup() async {');
    aggregatedBuffer.writeln('    _router = Router();');
    aggregatedBuffer.writeln('    _injector.dispose(_dispose);');
    aggregatedBuffer.writeln();

    final body = await buildStep //
        .findAssets(Glob('lib/**/*.dart'))
        .asyncExpand((assetId) async* {
      final library = await buildStep.resolver.libraryFor(assetId);
      final reader = LibraryReader(library);

      for (var classElement in reader.classes) {
        if (componentChecker.hasAnnotationOfExact(classElement)) {
          yield classElement;
          continue;
        }

        for (final meta in classElement.metadata) {
          final obj = meta.computeConstantValue();
          if (obj == null) continue;
          if (componentChecker.isAssignableFromType(obj.type!)) {
            yield classElement;
          }
        }
      }
    }).map((classElement) {
      final uri = classElement.librarySource.uri.toString();
      importSet.add(uri);
      return classElement;
    }).map((classElement) {
      final bodyBuffer = StringBuffer();
      bodyBuffer.writeln('    _injector.addSingleton(${classElement.name}.new);');

      if (configurationChecker.hasAnnotationOf(classElement)) {
        bodyBuffer.writeln(_configurationSetup(classElement));
      } else if (controllerChecker.hasAnnotationOf(classElement)) {
        bodyBuffer.writeln(_controllerSetup(classElement));
      }

      return bodyBuffer.toString();
    }).toList();

    aggregatedBuffer.writeln(body.join('\n'));

    aggregatedBuffer.writeln('    _injector.commit();');
    aggregatedBuffer.writeln('  }');

    aggregatedBuffer.writeln('}');

    importsBuffer.writeln(importSet.map((uri) => "import '$uri';").join('\n'));

    importsBuffer.writeln();
    importsBuffer.writeln(aggregatedBuffer.toString());

    final formattedCode = formatter.format(importsBuffer.toString());

    final outputId = _allFileOutput(buildStep);
    await buildStep.writeAsString(outputId, formattedCode);
  }

  bool libraryComponent(LibraryReader library) {
    for (final classElement in library.classes) {
      if (componentChecker.hasAnnotationOfExact(classElement)) {
        return true;
      }

      for (final meta in classElement.metadata) {
        final obj = meta.computeConstantValue();
        if (obj == null) continue;
        if (componentChecker.isAssignableFromType(obj.type!)) {
          return true;
        }
      }
    }
    return false;
  }

  String _configurationSetup(ClassElement classElement) {
    final bodyBuffer = StringBuffer();

    if (configurationChecker.hasAnnotationOf(classElement)) {
      for (final method in classElement.methods) {
        if (bindChecker.hasAnnotationOf(method)) {
          final positionalParams = method.parameters.where((p) => !p.isNamed).map((p) => '_injector()').toList();

          final namedParams = method.parameters.where((p) => p.isNamed && p.isRequiredNamed).map((p) => '${p.name}: _injector()').toList();

          final List<String> paramsList = [];
          if (positionalParams.isNotEmpty) {
            paramsList.add(positionalParams.join(', '));
          }
          if (namedParams.isNotEmpty) {
            paramsList.add(namedParams.join(', '));
          }
          final parameterResolution = paramsList.join(', ');

          if (method.returnType.isDartAsyncFuture) {
            bodyBuffer.writeln('    final _result_${classElement.name}_${method.name} = await ${classElement.name}().${method.name}($parameterResolution);');
            bodyBuffer.writeln('    _injector.addSingleton(() => _result_${classElement.name}_${method.name});');
          } else {
            if (method.parameters.isNotEmpty) {
              bodyBuffer.writeln('    _injector.addSingleton(() => ${classElement.name}().${method.name}($parameterResolution));');
            } else {
              bodyBuffer.writeln('    _injector.addSingleton(${classElement.name}().${method.name});');
            }
          }
        }
      }
    }

    return bodyBuffer.toString();
  }

  String _controllerSetup(ClassElement classElement) {
    final bodyBuffer = StringBuffer();

    String wrapGuard(String guardTypeName) {
      return """
(Handler inner) {
  return (Request request) async {
    final guard = _injector.get<$guardTypeName>();
    return await guard.handle(request, inner);
  };
}""";
    }

    String wrapMiddleware(String middlewareTypeName) {
      return """
(Handler inner) {
  return (Request request) async {
    final m = _injector.get<$middlewareTypeName>();
    return await m.handle(request, inner);
  };
}""";
    }

    final controllerAnn = controllerChecker.firstAnnotationOf(classElement);
    if (controllerAnn == null) return '';

    final controllerPath = controllerAnn.getField('path')?.toStringValue() ?? '';

    final controllerName = classElement.name;

    final classGuards = useGuardsChecker.firstAnnotationOf(classElement);
    final classMidds = useMiddlewareChecker.firstAnnotationOf(classElement);

    final routerVar = "_router$controllerName";
    bodyBuffer.writeln("final $routerVar = Router();");

    for (final method in classElement.methods) {
      String? routerMethod;
      String? routePath;

      for (final (checker, shelfMethod) in methodCheckers) {
        final httpAnn = checker.firstAnnotationOf(method);
        if (httpAnn != null) {
          routerMethod = shelfMethod;
          routePath = httpAnn.getField('path')?.toStringValue() ?? '';
          break;
        }
      }

      if (routerMethod == null) continue;

      final pipelineVar = "_pipeline_${controllerName}_${method.name}";
      bodyBuffer.writeln("var $pipelineVar = const Pipeline();");

      if (classGuards != null) {
        final guardList = classGuards.getField('guards')?.toListValue() ?? [];
        for (final g in guardList) {
          final guardTypeName = g.toTypeValue()?.getDisplayString();
          if (guardTypeName != null) {
            bodyBuffer.writeln("$pipelineVar = $pipelineVar.addMiddleware(${wrapGuard(guardTypeName)});");
          }
        }
      }
      if (classMidds != null) {
        final middList = classMidds.getField('middlewares')?.toListValue() ?? [];
        for (final m in middList) {
          final middTypeName = m.toTypeValue()?.getDisplayString();
          if (middTypeName != null) {
            bodyBuffer.writeln("$pipelineVar = $pipelineVar.addMiddleware(${wrapMiddleware(middTypeName)});");
          }
        }
      }

      final methodGuards = useGuardsChecker.firstAnnotationOf(method);
      final methodMidds = useMiddlewareChecker.firstAnnotationOf(method);

      if (methodGuards != null) {
        final guardList = methodGuards.getField('guards')?.toListValue() ?? [];
        for (final g in guardList) {
          final guardTypeName = g.toTypeValue()?.getDisplayString();
          if (guardTypeName != null) {
            bodyBuffer.writeln("$pipelineVar = $pipelineVar.addMiddleware(${wrapGuard(guardTypeName)});");
          }
        }
      }
      if (methodMidds != null) {
        final middList = methodMidds.getField('middlewares')?.toListValue() ?? [];
        for (final m in middList) {
          final middTypeName = m.toTypeValue()?.getDisplayString();
          if (middTypeName != null) {
            bodyBuffer.writeln("$pipelineVar = $pipelineVar.addMiddleware(${wrapMiddleware(middTypeName)});");
          }
        }
      }

      final paramCodeList = <String>[];
      for (final parameter in method.parameters) {
        final pAnn = paramChecker.firstAnnotationOf(parameter);
        final qAnn = queryChecker.firstAnnotationOf(parameter);

        if (pAnn != null) {
          final pname = pAnn.getField('name')?.toStringValue() ?? parameter.name;
          paramCodeList.add("final ${parameter.name} = request.params['$pname']; // String?");
        } else if (qAnn != null) {
          final qname = qAnn.getField('name')?.toStringValue() ?? parameter.name;
          paramCodeList.add("final ${parameter.name} = request.url.queryParameters['$qname']; // String?");
        } else {
          final paramType = parameter.type.getDisplayString();
          if (paramType == 'Request' || paramType == 'Request?') {
            if (parameter.name != 'request') {
              paramCodeList.add("final ${parameter.name} = request;");
            }
          }
        }
      }

      final handlerVar = "_handler_${controllerName}_${method.name}";
      bodyBuffer.writeln("final $handlerVar = (Request request) async {");
      for (final code in paramCodeList) {
        bodyBuffer.writeln("  $code");
      }
      final callParams = method.parameters.map((p) => p.name).join(', ');
      bodyBuffer.writeln("  final ctrl = _injector.get<$controllerName>();");
      bodyBuffer.writeln("  final result = await ctrl.${method.name}($callParams);");
      bodyBuffer.writeln("  return result;");
      bodyBuffer.writeln("};");

      bodyBuffer.writeln("$routerVar.$routerMethod('$routePath', $pipelineVar.addHandler($handlerVar));");
    }

    bodyBuffer.writeln("_router.mount('$controllerPath', $routerVar);");

    return bodyBuffer.toString();
  }
}

Builder aggregatingVadenBuilder(BuilderOptions options) => AggregatingVadenBuilder();
