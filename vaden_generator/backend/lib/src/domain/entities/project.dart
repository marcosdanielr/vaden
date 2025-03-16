// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:backend/src/domain/entities/dependency.dart';
import 'package:vaden/vaden.dart';

@DTO()
class Project with Validator<Project> {
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

  @override
  LucidValidator<Project> validate(ValidatorBuilder<Project> builder) {
    builder //
        .ruleFor((p) => p.dependencies, key: 'dependencies')
        .use((dependencies, project) {
      if (dependencies.isEmpty) {
        return null;
      }
      final validate = ValidatorBuilder<Dependency>();
      dependencies.first.validate(validate);

      for (var dependency in dependencies) {
        dependency.validate(validate);
        final result = validate.validate(dependency);
        if (!result.isValid) {
          return result.exceptions.first;
        }
      }
      return null;
    });

    builder //
        .ruleFor((p) => p.projectName, key: 'projectName')
        .notEmpty()
        .matchesPattern(r"^[a-z0-9_]+$", message: "Invalid project name");

    builder //
        .ruleFor((p) => p.projectDescription, key: 'projectDescription')
        .notEmpty();

    builder //
        .ruleFor((p) => p.dartVersion, key: 'dartVersion')
        .notEmpty()
        .matchesPattern(r"^\d+\.\d+\.\d+$", message: "Invalid dart version");

    return builder;
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
