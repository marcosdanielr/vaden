// GENERATED CODE - DO NOT MODIFY BY HAND
// Aggregated Vaden application file

import 'package:vaden/vaden.dart';

import 'package:example/src/auth_configuration.dart';
import 'package:example/src/auth_controller.dart';
import 'package:example/src/auth_guard.dart';
import 'package:example/src/auth_service.dart';

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

    _injector.addSingleton(AuthController.new);
    final _routerAuthController = Router();
    var _pipeline_AuthController_ping = const Pipeline();
    final _handler_AuthController_ping = (Request request) async {
      final ctrl = _injector.get<AuthController>();
      final result = await ctrl.ping();
      return result;
    };
    _routerAuthController.get(
      '/ping',
      _pipeline_AuthController_ping.addHandler(_handler_AuthController_ping),
    );
    var _pipeline_AuthController_other = const Pipeline();
    _pipeline_AuthController_other = _pipeline_AuthController_other
        .addMiddleware((Handler inner) {
          return (Request request) async {
            final guard = _injector.get<AuthGuard>();
            return await guard.handle(request, inner);
          };
        });
    final _handler_AuthController_other = (Request request) async {
      final id = request.url.queryParameters['id']; // String?
      final ctrl = _injector.get<AuthController>();
      final result = await ctrl.other(id);
      return result;
    };
    _routerAuthController.get(
      '/other',
      _pipeline_AuthController_other.addHandler(_handler_AuthController_other),
    );
    var _pipeline_AuthController_login = const Pipeline();
    final _handler_AuthController_login = (Request request) async {
      final ctrl = _injector.get<AuthController>();
      final result = await ctrl.login(credentials);
      return result;
    };
    _routerAuthController.post(
      '/login',
      _pipeline_AuthController_login.addHandler(_handler_AuthController_login),
    );
    _router.mount('/auth', _routerAuthController);

    _injector.addSingleton(AuthGuard.new);

    _injector.addSingleton(AuthService.new);

    _injector.commit();
  }
}
