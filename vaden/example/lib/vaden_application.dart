// GENERATED CODE - DO NOT MODIFY BY HAND
// Aggregated Vaden application file

import 'package:vaden/vaden.dart';

import 'package:example/src/auth/auth_controller.dart';

import 'package:example/src/auth/auth_guard.dart';

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

    _injector.addSingleton(AuthController.new);

    final _routerAuthController = Router();
    var _pipeline_AuthController_login = const Pipeline();
    _pipeline_AuthController_login = _pipeline_AuthController_login
        .addMiddleware((Handler inner) {
          return (Request request) async {
            final guard = _injector.get<AuthGuard>();
            return await guard.handle(request, inner);
          };
        });
    final _handler_AuthController_login = (Request request) async {
      final ctrl = _injector.get<AuthController>();
      final result = await ctrl.login(request);
      return result;
    };
    _routerAuthController.post(
      '/login',
      _pipeline_AuthController_login.addHandler(_handler_AuthController_login),
    );
    _router.mount('/auth', _routerAuthController);

    _injector.addSingleton(AuthGuard.new);

    _injector.commit();
  }
}
