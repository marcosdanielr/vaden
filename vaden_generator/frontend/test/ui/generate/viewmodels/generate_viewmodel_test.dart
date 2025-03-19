import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/repositories/generate_repository.dart';
import 'package:frontend/domain/entities/dependency.dart';
import 'package:frontend/domain/entities/project.dart';
import 'package:frontend/ui/generate/viewmodels/generate_viewmodel.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockGenerateRepository extends Mock implements GenerateRepository {}

class DependencyFake extends Fake implements Dependency {}

class ProjectFake extends Fake implements Project {}

void main() {
  late GenerateRepository generateRepository;
  late GenerateViewmodel viewmodel;

  setUpAll(() {
    registerFallbackValue(ProjectFake());
  });

  setUp(() {
    generateRepository = MockGenerateRepository();
    viewmodel = GenerateViewmodel(generateRepository);
  });

  test('fetch dependencies comnand', () async {
    when(() => generateRepository.getDependencies())
        .thenAnswer((_) async => Success([DependencyFake()]));

    await viewmodel.fetchDependenciesCommand.execute();

    expect(viewmodel.fetchDependenciesCommand.isSuccess, true);
    expect(viewmodel.dependencies.isNotEmpty, true);
  });

  test('add end remove project dependencies', () async {
    viewmodel.setDependencies([DependencyFake()]);
    final dependency = viewmodel.dependencies;

    expect(viewmodel.projectDependencies.isEmpty, true);

    await viewmodel.addDependencyOnProjectCommand.execute(dependency.first);

    expect(viewmodel.projectDependencies.isNotEmpty, true);

    await viewmodel.removeDependencyOnProjectCommand.execute(dependency.first);

    expect(viewmodel.projectDependencies.isEmpty, true);
  });

  test('create project comnand', () async {
    when(() => generateRepository.createZip(any()))
        .thenAnswer((_) async => Success(unit));

    await viewmodel.createProjectCommand.execute(Project());

    expect(viewmodel.createProjectCommand.isSuccess, true);
  });
}
