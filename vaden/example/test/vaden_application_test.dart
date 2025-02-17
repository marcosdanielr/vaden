import 'package:example/src/other_credentials.dart';
import 'package:example/vaden_application.dart';
import 'package:test/test.dart';
import 'package:vaden/vaden.dart';

void main() {
  test('vaden application ...', () async {
    final app = VadenApplication();

    await app.setup();

    final factory = app.injector.get<DTOFactory>();

    final credentials = factory.fromJson<OtherCredentials>({
      'other': 'other',
      'credentials': {
        'user_name': 'user',
        'password': 'Password1!',
      }
    })!;

    expect(credentials.credentials.username, 'user');
    expect(credentials.credentials.password, 'Password1!');
    expect(credentials.other, 'other');
  });
}
