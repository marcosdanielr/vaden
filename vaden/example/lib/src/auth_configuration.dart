import 'package:vaden/vaden.dart';

@Configuration()
class AuthConfiguration {
  @Bind()
  MyEnv myEnv() {
    return MyEnv('http://localhost:3000', 'my-token');
  }
}

class MyEnv {
  final String url;
  final String token;

  MyEnv(this.url, this.token);
}
