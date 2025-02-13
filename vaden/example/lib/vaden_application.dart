// GENERATED CODE - DO NOT MODIFY BY HAND
// Aggregated Vaden application file

import 'dart:convert';
import 'package:vaden/vaden.dart';

import 'package:example/src/auth_configuration.dart';
import 'package:example/src/auth_controllar.dart';
import 'package:example/src/auth_service.dart';
import 'package:example/src/auth_guard.dart';
import 'package:example/src/credentials.dart';

class VadenApplication {
  var _router = Router();
  var _injector = AutoInjector();

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

    _injector.addSingleton(AuthConfiguration.new);
    _injector.addSingleton(AuthConfiguration().myEnv);

    _injector.addSingleton(AuthControllar.new);
    final _routerAuthControllar = Router();
    var _pipeline_AuthControllar_ping = const Pipeline();
    _pipeline_AuthControllar_ping = _pipeline_AuthControllar_ping.addMiddleware(
      (Handler inner) {
        return (Request request) async {
          final guard = _injector.get<AuthGuard>();
          return await guard.handle(request, inner);
        };
      },
    );
    final _handler_AuthControllar_ping = (Request request) async {
      final ctrl = _injector.get<AuthControllar>();
      final result = await ctrl.ping();
      return result;
    };
    _routerAuthControllar.get(
      '/ping',
      _pipeline_AuthControllar_ping.addHandler(_handler_AuthControllar_ping),
    );
    var _pipeline_AuthControllar_other = const Pipeline();
    final _handler_AuthControllar_other = (Request request) async {
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
    };
    _routerAuthControllar.get(
      '/other/<id>',
      _pipeline_AuthControllar_other.addHandler(_handler_AuthControllar_other),
    );
    var _pipeline_AuthControllar_login = const Pipeline();
    final _handler_AuthControllar_login = (Request request) async {
      final _bodyString = await request.readAsString();
      final _json = jsonDecode(_bodyString) as Map<String, dynamic>;
      final credentials = Credentials.fromJson(_json);
      if (credentials is Validator<Credentials>) {
        final _validator = credentials.validate(
          ValidatorBuilder<Credentials>(),
        );
        final _resultValidator = _validator.validate(credentials);
        if (!_resultValidator.isValid) {
          return Response(
            400,
            body: jsonEncode(_resultValidator.exceptionToJson()),
          );
        }
      }

      final ctrl = _injector.get<AuthControllar>();
      final result = await ctrl.login(credentials);
      return result;
    };
    _routerAuthControllar.post(
      '/login',
      _pipeline_AuthControllar_login.addHandler(_handler_AuthControllar_login),
    );
    _router.mount('/auth', _routerAuthControllar);

    _injector.addSingleton(AuthService.new);

    _injector.addSingleton(AuthGuard.new);

    _injector.addSingleton(Credentials.new);

    _injector.commit();
  }
}
