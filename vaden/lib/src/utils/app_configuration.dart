import 'dart:io';

import 'package:yaml/yaml.dart';

class ApplicationSettings {
  final Map _yamlMap;

  ApplicationSettings._(this._yamlMap);

  static ApplicationSettings load(String path) {
    final file = File(path);
    final content = file.readAsStringSync();
    final yamlMap = loadYaml(content) as YamlMap;

    final config = ApplicationSettings._(yamlMap);
    return config;
  }

  dynamic operator [](String key) {
    return _yamlMap[key];
  }
}
