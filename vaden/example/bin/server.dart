import 'dart:io';

import 'package:example/vaden_application.dart';
import 'package:vaden/vaden.dart';

void main(List<String> args) async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final vaden = VadenApplication();
  await vaden.setup();
  final server = await serve(vaden.run, '0.0.0.0', port);
  print('Server listening on port ${server.port}');
}
