import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/generate_repository.dart';
import '../../../domain/entities/dependency.dart';
import '../../../domain/entities/project.dart';

mixin _StateGenerate on ChangeNotifier {
  final List<String> _dartVersions = ['3.7.2', '3.7.1'];
  List<String> get dartVersions => _dartVersions;

  String get latestDartVersion => _dartVersions.isNotEmpty ? _dartVersions.first : '';

  List<Dependency> _dependencies = [];
  List<Dependency> get dependencies => _dependencies;

  @visibleForTesting
  void setDependencies(List<Dependency> dependencies) {
    _dependencies = dependencies;
  }

  void _setDependencies(List<Dependency> dependencies) {
    _dependencies = dependencies;
    notifyListeners();
  }

  final Project _project = Project();
  Project get project => _project;

  bool projectIsValid() {
    if (project.name.isEmpty) {
      return false;
    }
    if (project.description.isEmpty) {
      return false;
    }
    if (project.dartVersion.isEmpty) {
      return false;
    }
    // if (project.dependencies.isEmpty) {
    //   return false;
    // }
    return true;
  }

  void _setName(String name) {
    _project.setName(name);
    notifyListeners();
  }

  void _setDescription(String description) {
    _project.setDescription(description);
    notifyListeners();
  }

  void _setDartVersion(String dartVersion) {
    _project.setDartVersion(dartVersion);
    notifyListeners();
  }

  final List<Dependency> _projectDependencies = [];
  List<Dependency> get projectDependencies => _projectDependencies;

  void _addDependencyOnProject(Dependency dependency) {
    _projectDependencies.add(dependency);
    project.setDependencies(_projectDependencies);
    notifyListeners();
  }

  void _removeDependencyOnProject(Dependency dependency) {
    _projectDependencies.remove(dependency);
    project.setDependencies(_projectDependencies);
    notifyListeners();
  }
}

class GenerateViewmodel extends ChangeNotifier with _StateGenerate {
  GenerateViewmodel(this._generateRepository) {
    // Define a versão mais recente do Dart como padrão
    if (latestDartVersion.isNotEmpty) {
      _setDartVersion(latestDartVersion);
    }
  }
  final GenerateRepository _generateRepository;

  late final fetchDependenciesCommand = Command0<List<Dependency>>(_fetchDependencies);
  late final setNameProjectCommand = Command1<Unit, String>(_setNameProject);
  late final setDescriptionProjectCommand = Command1<Unit, String>(_setDescriptionProject);
  late final setDartVersionProjectCommand = Command1<Unit, String>(_setDartVersionProject);
  late final addDependencyOnProjectCommand = Command1<Unit, Dependency>(_addDependency);
  late final removeDependencyOnProjectCommand = Command1<Unit, Dependency>(_removeDependency);
  late final createProjectCommand = Command0<Unit>(_createProject);

  AsyncResult<List<Dependency>> _fetchDependencies() {
    return _generateRepository //
        .getDependencies()
        .onSuccess(_setDependencies);
  }

  AsyncResult<Unit> _setNameProject(String name) async {
    _setName(name);
    return const Success(unit);
  }

  AsyncResult<Unit> _setDescriptionProject(String description) async {
    _setDescription(description);
    return const Success(unit);
  }

  AsyncResult<Unit> _setDartVersionProject(String dartVersion) async {
    _setDartVersion(dartVersion);
    return const Success(unit);
  }

  AsyncResult<Unit> _addDependency(Dependency dependency) async {
    _addDependencyOnProject(dependency);
    return const Success(unit);
  }

  AsyncResult<Unit> _removeDependency(Dependency dependency) async {
    _removeDependencyOnProject(dependency);
    return const Success(unit);
  }

  AsyncResult<Unit> _createProject() {
    return _generateRepository //
        .createZip(_project);
  }
}
