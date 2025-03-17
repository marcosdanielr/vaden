import 'dependency_dto.dart';

class ProjectDto {
  String _name;
  String _description;
  String _dartVersion;
  List<DependencyDTO> _dependencies;

  ProjectDto._(
    this._name,
    this._description,
    this._dartVersion,
    this._dependencies,
  );

  factory ProjectDto() {
    return ProjectDto._('', '', '', []);
  }

  String get name => _name;
  void setName(String value) => _name = value;

  String get description => _description;
  void setDescription(String value) => _description = value;

  String get dartVersion => _dartVersion;
  void setDartVersion(String value) => _dartVersion = value;

  List<DependencyDTO> get dependencies => _dependencies;
  void setDependencies(List<DependencyDTO> value) => _dependencies = value;
}
