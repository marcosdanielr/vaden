import 'dart:io';

import 'package:backend/src/core/files/file_manager.dart';

abstract class FileGenerator {
  Future<void> generate(
    FileManager fileManager,
    Directory directory, {
    Map<String, dynamic> variables = const {},
  });

  /// parse variables in content
  /// Variables is {{variable}} or {{ variable }}
  String parseVariables(String content, Map<String, dynamic> variables) {
    final regExp = RegExp(r'{{\s*([a-zA-Z0-9_]+)\s*}}');
    return content.replaceAllMapped(regExp, (match) {
      final key = match.group(1);
      return variables[key] ?? '';
    });
  }
}
