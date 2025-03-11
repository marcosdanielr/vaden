import 'package:backend/src/domain/dtos/dependency_dto.dart';
import 'package:backend/src/domain/entities/project.dart';
import 'package:vaden/vaden.dart';

@DTO()
class ProjectDTO {
  final List<DependencyDTO> dependencies;
  final String projectName;
  final String projectDescription;
  final String dartVersion;

  ProjectDTO({
    this.dependencies = const [],
    required this.projectName,
    required this.projectDescription,
    this.dartVersion = '3.6.0',
  });

  static ProjectDTO fromGenerateInfo(Project project) {
    return ProjectDTO(
      dependencies: DependencyDTO.fromDependencies(project.dependencies),
      projectName: project.projectName,
      projectDescription: project.projectDescription,
      dartVersion: project.dartVersion,
    );
  }

  Project toProject() {
    return Project(
      dependencies: dependencies.map((e) => e.toDependency()).toList(),
      projectName: projectName,
      projectDescription: projectDescription,
      dartVersion: dartVersion,
    );
  }
}
