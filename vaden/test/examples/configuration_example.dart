import 'package:vaden/vaden.dart';

@Configuration()
class ExampleConfiguration {
  @Provider()
  MyEnv getProjectEnv() {
    return MyEnv(
      String.fromEnvironment('URL_API'),
      String.fromEnvironment('TOKEN'),
    );
  }
}

class MyEnv {
  final String urlApi;
  final String token;

  MyEnv(this.urlApi, this.token);
}
