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

  Future<void> setDependencies() async {
    when(() => generateRepository.getDependencies())
        .thenAnswer((_) async => Success([DependencyFake()]));

    await viewmodel.fetchDependenciesComnand.execute();
  }

  test('fetch dependencies comnand', () async {
    when(() => generateRepository.getDependencies())
        .thenAnswer((_) async => Success([DependencyFake()]));

    await viewmodel.fetchDependenciesComnand.execute();

    expect(viewmodel.fetchDependenciesComnand.isSuccess, true);
    expect(viewmodel.dependencies.isNotEmpty, true);
  });

  test('add end remove project dependencies', () async {
    await setDependencies();
    final dependency = viewmodel.dependencies;

    expect(viewmodel.projectDependencies.isEmpty, true);

    await viewmodel.addDependencyOnProjectComnand.execute(dependency.first);

    expect(viewmodel.projectDependencies.isNotEmpty, true);

    await viewmodel.removeDependencyOnProjectComnand.execute(dependency.first);

    expect(viewmodel.projectDependencies.isEmpty, true);
  });

  test('create project comnand', () async {
    when(() => generateRepository.createZip(any()))
        .thenAnswer((_) async => Success(unit));

    await viewmodel.createProjectComnand.execute(Project());

    expect(viewmodel.createProjectComnand.isSuccess, true);
  });
}
