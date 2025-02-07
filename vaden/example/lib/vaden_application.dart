// GENERATED CODE - DO NOT MODIFY BY HAND
// Aggregated Vaden application file

import 'package:vaden/vaden.dart';

import 'package:example/src/auth/auth_controller.dart';
import 'package:example/src/product/product_controller.dart';

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
    final router = Router();
    _injector.dispose(_dispose);
    final injector = AutoInjector();

      injector.add(AuthController.new);

      final routerAuthController = Router();
      routerAuthController.get('/', (Request request) async {
        final controller = injector.get<AuthController>();
        return controller.index(request);
      });

      router.mount('/AuthController', routerAuthController);

      injector.add(ProductController.new);

      final routerProductController = Router();
      routerProductController.get('/', (Request request) async {
        final controller = injector.get<ProductController>();
        return controller.index(request);
      });

      router.mount('/ProductController', routerProductController);

    injector.commit();
  }
}

