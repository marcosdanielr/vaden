import 'package:vaden/vaden.dart';

import 'auth_service.dart';
import 'envtest.dart';

@Service()
class AuthServiceImpl implements AuthService {
  final MyEnv _myEnv;

  AuthServiceImpl(this._myEnv);

  @override
  String ping() {
    return 'pong ${_myEnv.apiURL}';
  }
}
