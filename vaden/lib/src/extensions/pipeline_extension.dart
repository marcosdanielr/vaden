part of 'extensions.dart';

extension PipelineExtension on Pipeline {
  addGuard(VadenGuard guard) {
    addMiddleware(guard.toMiddleware());
  }

  addVadenMiddleware(VadenMiddleware middleware) {
    addMiddleware(middleware.toMiddleware());
  }
}
