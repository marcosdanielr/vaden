import '../../domain/entities/dependency.dart';
import '../../domain/entities/project.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class GenerateRepository {
  AsyncResult<List<Dependency>> getDependencies();

  AsyncResult<Unit> createZip(Project project);
}
