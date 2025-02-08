import 'package:vaden/vaden.dart';

@Configuration()
class AuthConfiguration {
  @Bind()
  MyEnv myEnv() {
    return MyEnv('http://localhost:3000', '123456');
  }
}

class MyEnv {
  final String urlAPI;
  final String token;

  MyEnv(this.urlAPI, this.token);
}
