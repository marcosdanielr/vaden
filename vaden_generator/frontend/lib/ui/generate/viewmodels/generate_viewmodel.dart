import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/generate_repository.dart';
import '../../../domain/entities/dependency.dart';
import '../../../domain/entities/project.dart';

mixin _StateGenerate on ChangeNotifier {
  List<Dependency> _dependencies = [];
  List<Dependency> get dependencies => _dependencies;

  void _setDependencies(List<Dependency> dependencies) {
    _dependencies = dependencies;
    notifyListeners();
  }

  final List<Dependency> _projectDependencies = [];
  List<Dependency> get projectDependencies => _projectDependencies;

  void _addDependencyOnPorject(Dependency dependency) {
    _projectDependencies.add(dependency);
    notifyListeners();
  }

  void _removeDependencyOnPorject(Dependency dependency) {
    _projectDependencies.remove(dependency);
    notifyListeners();
  }
}

class GenerateViewmodel extends ChangeNotifier with _StateGenerate {
  GenerateViewmodel(this._generateRepository);
  final GenerateRepository _generateRepository;

  late final fetchDependenciesCommand =
      Command0<List<Dependency>>(_fetchDependencies);
  late final addDependencyOnProjectCommand =
      Command1<Unit, Dependency>(_addDependency);
  late final removeDependencyOnProjectCommand =
      Command1<Unit, Dependency>(_removeDependency);
  late final createProjectCommand = Command1<Unit, Project>(_createProject);

  AsyncResult<List<Dependency>> _fetchDependencies() {
    return _generateRepository //
        .getDependencies()
        .onSuccess(_setDependencies);
  }

  AsyncResult<Unit> _addDependency(Dependency dependency) async {
    _addDependencyOnPorject(dependency);
    return const Success(unit);
  }

  AsyncResult<Unit> _removeDependency(Dependency dependency) async {
    _removeDependencyOnPorject(dependency);
    return const Success(unit);
  }

  AsyncResult<Unit> _createProject(Project project) {
    return _generateRepository //
        .createZip(project);
  }
}
