// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DependencyDTO {
  final String name;
  final String version;
  final String tag;

  DependencyDTO({
    required this.name,
    required this.version,
    required this.tag,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'version': version,
      'tag': tag,
    };
  }

  factory DependencyDTO.fromMap(Map<String, dynamic> map) {
    return DependencyDTO(
      name: map['name'] as String,
      version: map['version'] as String,
      tag: map['tag'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DependencyDTO.fromJson(String source) => DependencyDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
