import 'dart:convert';

class DependencyDTO {
  final String name;
  final String description;
  final String key;
  final String tag;

  DependencyDTO({
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

  factory DependencyDTO.fromMap(Map<String, dynamic> map) {
    return DependencyDTO(
      name: map['name'] as String,
      description: map['description'] as String,
      key: map['key'] as String,
      tag: map['tag'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DependencyDTO.fromJson(String source) =>
      DependencyDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
