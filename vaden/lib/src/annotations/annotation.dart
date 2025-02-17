part 'openapi.dart';
part 'rest.dart';

class Component {
  const Component();
}

class Service extends Component {
  const Service();
}

class Repository extends Component {
  const Repository();
}

class Configuration extends Component {
  const Configuration();
}

class Bind {
  const Bind();
}

class Controller extends Component {
  final String path;

  const Controller(this.path);
}

class DTO extends Component {
  const DTO();
}

class JsonKey {
  final String name;
  const JsonKey(this.name);
}

class JsonIgnore {
  const JsonIgnore();
}

class UseMiddleware {
  final List<Type> middlewares;
  const UseMiddleware(this.middlewares);
}

class UseGuards {
  final List<Type> guards;
  const UseGuards(this.guards);
}

class Query {
  final String name;
  const Query(this.name);
}

class Param {
  final String name;

  const Param(this.name);
}

class Body {
  const Body();
}
