part of 'annotation.dart';

class UseMiddleware {
  const UseMiddleware();
}

class UseGuards {
  final List<Middleware> middleware;
  const UseGuards(this.middleware);
}
