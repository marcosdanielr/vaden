import 'dart:convert';

import 'dependency.dart';

class Project {
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

  void setName(String value) => name = value;

  void setDescription(String value) => description = value;

  void setDartVersion(String value) => dartVersion = value;

  void setDependencies(List<Dependency> value) => dependencies = value;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'dartVersion': dartVersion,
      'dependencies': dependencies.map((x) => x.toMap()).toList(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project._(
      map['name'] ?? '',
      map['description'] ?? '',
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
