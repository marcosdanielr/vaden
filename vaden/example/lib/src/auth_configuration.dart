import 'package:example/src/credentials.dart';
import 'package:vaden/vaden.dart';

import 'envtest.dart';

@Configuration()
class AuthConfiguration {
  @Bind()
  MyEnv myEnv(DTOFactory factory) {
    final credentials = Credentials('myUsername', 'myPassword');

    final json = factory.toJson(credentials);

    final cred = factory.fromJson<Credentials>(
      {
        'user_name': 'myUsername',
        'password': 'myPassword',
      },
    );

    return MyEnv('http://localhost:3000', 'myToken');
  }
}
