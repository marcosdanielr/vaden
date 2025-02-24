part of 'extensions.dart';

extension PipelineExtension on Pipeline {
  Pipeline addGuard(VadenGuard guard) {
    return addMiddleware(guard.toMiddleware());
  }

  Pipeline addVadenMiddleware(VadenMiddleware middleware) {
    return addMiddleware(middleware.toMiddleware());
  }
}
