import 'package:backend/src/domain/entities/dependency.dart';
import 'package:vaden/vaden.dart';

@DTO()
class DependencyDTO {
  final String name;
  final String version;
  final String tag;

  DependencyDTO({
    required this.name,
    required this.version,
    required this.tag,
  });

  static DependencyDTO fromDependency(Dependency dependency) {
    return DependencyDTO(
      name: dependency.name,
      version: dependency.version,
      tag: dependency.tag,
    );
  }

  static List<DependencyDTO> fromDependencies(List<Dependency> dependency) {
    return dependency //
        .map(DependencyDTO.fromDependency)
        .toList();
  }

  Dependency toDependency() {
    return Dependency(
      name: name,
      version: version,
      tag: tag,
    );
  }
}
