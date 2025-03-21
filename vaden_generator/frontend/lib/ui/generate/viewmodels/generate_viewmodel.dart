import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/generate_repository.dart';
import '../../../domain/entities/dependency.dart';
import '../../../domain/entities/project.dart';

class GenerateViewmodel extends ChangeNotifier {
  GenerateViewmodel(this._generateRepository);
  final GenerateRepository _generateRepository;

  late final fetchDependenciesCommand = Command0<List<Dependency>>(_fetchDependencies);
  late final createProjectCommand = Command1(_createProject);

  final List<String> dartVersions = ['3.6.0', '3.7.1', '3.7.2'];
  String get latestDartVersion => dartVersions.isNotEmpty ? dartVersions.first : '';
  List<Dependency> _dependencies = [];
  List<Dependency> get dependencies => _dependencies;

  void _setDependencies(List<Dependency> dependencies) {
    _dependencies = dependencies;
    notifyListeners();
  }

  final List<Dependency> _projectDependencies = [];
  List<Dependency> get projectDependencies => _projectDependencies;

  AsyncResult<List<Dependency>> _fetchDependencies() {
    return _generateRepository //
        .getDependencies()
        .onSuccess(_setDependencies);
  }

  AsyncResult<Unit> _createProject(Project project) {
    return _generateRepository //
        .createZip(project);
  }
}
