// GENERATED CODE - DO NOT MODIFY BY HAND
// Aggregated Vaden application file

import 'package:vaden/vaden.dart';


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

    injector.commit();
  }
}

