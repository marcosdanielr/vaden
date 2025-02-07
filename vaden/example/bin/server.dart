import 'dart:io';

import 'package:example/vaden_application.dart';
import 'package:vaden/vaden.dart';

void main(List<String> args) async {
  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(VadenApplication.run, ip, port);
  print('Server listening on port ${server.port}');
}
