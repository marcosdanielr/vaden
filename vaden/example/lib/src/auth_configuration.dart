import 'package:vaden/vaden.dart';

@Configuration()
class AuthConfiguration {
  @Bind()
  MyEnv myEnv() {
    return MyEnv('http://localhost:3000', 'myToken');
  }
}

class MyEnv {
  final String apiURL;
  final String token;

  MyEnv(this.apiURL, this.token);
}
