import 'package:vaden/vaden.dart';

import 'envtest.dart';

@Configuration()
class AuthConfiguration {
  @Bind()
  MyEnv myEnv() {
    return MyEnv('http://localhost:3000', 'myToken');
  }
}
