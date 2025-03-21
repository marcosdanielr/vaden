import 'dart:convert';

import 'package:flutter/material.dart';

import 'dependency.dart';

class Project extends ChangeNotifier {
  String name;
  String description;
  String dartVersion;
  List<Dependency> dependencies;

  Project._(
    this.name,
    this.description,
    this.dartVersion,
    this.dependencies,
  );

  factory Project() {
    return Project._('', '', '', []);
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setDartVersion(String value) {
    dartVersion = value;
    notifyListeners();
  }

  void setDependencies(List<Dependency> value) => dependencies = value;

  Map<String, dynamic> toMap() {
    return {
      'projectName': name,
      'projectDescription': description,
      'dartVersion': dartVersion,
      'dependencies': dependencies.map((x) => x.toMap()).toList(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project._(
      map['projectName'] ?? '',
      map['projectDescription'] ?? '',
      map['dartVersion'] ?? '',
      List<Dependency>.from(
        map['dependencies']?.map(
          (x) => Dependency.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Project.fromJson(String source) => Project.fromMap(json.decode(source));
}
