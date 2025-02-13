// GENERATED CODE - DO NOT MODIFY BY HAND
// Aggregated Vaden application file

import 'dart:convert';

import 'package:example/src/auth_configuration.dart';
import 'package:example/src/auth_controllar.dart';
import 'package:example/src/auth_guard.dart';
import 'package:example/src/auth_service.dart';
import 'package:example/src/credentials.dart';
import 'package:vaden/vaden.dart';

class VadenApplication {
  var _router = Router();
  final _injector = AutoInjector();

  VadenApplication();

  void _dispose(dynamic instance) {
    if (instance is Disposable) {
      instance.dispose();
    }
  }

  Future<Response> run(Request request) async {
    return _router(request);
  }

  Future<void> setup() async {
    _router = Router();
    _injector.dispose(_dispose);

    final config = ApplicationSettings.load('application.yaml');
    _injector.addInstance(config);

    _injector.addSingleton(AuthConfiguration.new);
    _injector.addSingleton(AuthConfiguration().myEnv);

    _injector.addSingleton(AuthControllar.new);
    final routerAuthControllar = Router();
    var pipelineAuthcontrollarPing = const Pipeline();
    pipelineAuthcontrollarPing = pipelineAuthcontrollarPing.addMiddleware(
      (Handler inner) {
        return (Request request) async {
          final guard = _injector.get<AuthGuard>();
          return await guard.handle(request, inner);
        };
      },
    );
    handler_AuthControllar_ping(Request request) async {
      final ctrl = _injector.get<AuthControllar>();
      final result = await ctrl.ping();
      return result;
    }

    routerAuthControllar.get(
      '/ping',
      pipelineAuthcontrollarPing.addHandler(handler_AuthControllar_ping),
    );
    var pipelineAuthcontrollarOther = const Pipeline();
    handler_AuthControllar_other(Request request) async {
      if (request.params['id'] == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid parameter (id)'}),
        );
      }
      final id = request.params['id']!;

      final ctrl = _injector.get<AuthControllar>();
      final result = await ctrl.other(id);
      return result;
    }

    routerAuthControllar.get(
      '/other/<id>',
      pipelineAuthcontrollarOther.addHandler(handler_AuthControllar_other),
    );
    var pipelineAuthcontrollarLogin = const Pipeline();
    handler_AuthControllar_login(Request request) async {
      final bodyString = await request.readAsString();
      final json = jsonDecode(bodyString) as Map<String, dynamic>;
      final credentials = Credentials.fromJson(json);
      final validator = credentials.validate(
        ValidatorBuilder<Credentials>(),
      );
      final resultValidator = validator.validate(credentials);
      if (!resultValidator.isValid) {
        return Response(
          400,
          body: jsonEncode(resultValidator.exceptionToJson()),
        );
      }

      final ctrl = _injector.get<AuthControllar>();
      final result = await ctrl.login(credentials);
      return result;
    }

    routerAuthControllar.post(
      '/login',
      pipelineAuthcontrollarLogin.addHandler(handler_AuthControllar_login),
    );
    _router.mount('/auth', routerAuthControllar.call);

    _injector.addSingleton(AuthGuard.new);

    _injector.addSingleton(AuthService.new);

    _injector.addSingleton(Credentials.new);

    _injector.commit();
  }
}
