import 'dart:convert';

class Dependency {
  final String name;
  final String description;
  final String key;
  final String tag;

  Dependency({
    required this.name,
    required this.description,
    required this.key,
    required this.tag,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'key': key,
      'tag': tag,
    };
  }

  factory Dependency.fromMap(Map<String, dynamic> map) {
    return Dependency(
      name: map['name'] as String,
      description: map['description'] as String,
      key: map['key'] as String,
      tag: map['tag'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Dependency.fromJson(String source) =>
      Dependency.fromMap(json.decode(source) as Map<String, dynamic>);
}
