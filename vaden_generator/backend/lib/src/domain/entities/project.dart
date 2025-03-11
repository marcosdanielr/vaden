// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:backend/src/domain/entities/dependency.dart';

class Project {
  final List<Dependency> dependencies;
  final String projectName;
  final String projectDescription;
  final String dartVersion;

  Project({
    required this.dependencies,
    required this.projectName,
    required this.projectDescription,
    required this.dartVersion,
  });

  ProjectWithTempPath addPath(String path) {
    return ProjectWithTempPath(
      path: path,
      dependencies: dependencies,
      projectName: projectName,
      projectDescription: projectDescription,
      dartVersion: dartVersion,
    );
  }
}

class ProjectWithTempPath extends Project {
  final String path;

  ProjectWithTempPath({
    required this.path,
    required super.dependencies,
    required super.projectName,
    required super.projectDescription,
    required super.dartVersion,
  });
}
