import 'package:vaden/vaden.dart';

import 'envtest.dart';

@Service()
class AuthService {
  final MyEnv _myEnv;

  AuthService(this._myEnv);

  String ping() {
    return 'pong ${_myEnv.apiURL}';
  }
}
