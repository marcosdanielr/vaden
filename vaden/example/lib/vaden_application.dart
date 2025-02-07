// GENERATED CODE - DO NOT MODIFY BY HAND
// Aggregated Vaden application file

import 'package:vaden/vaden.dart';

import 'package:example/src/auth/auth_controller.dart';
import 'package:example/src/product/product_controller.dart';

abstract class VadenApplication {

  static Future<Response> run(Request request) async {
    final router = Router();
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
    return router(request);
  }
}

