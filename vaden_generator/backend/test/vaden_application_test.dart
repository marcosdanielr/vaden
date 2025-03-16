import 'package:backend/src/domain/dtos/dependency_dto.dart';
import 'package:backend/src/domain/dtos/project_dto.dart';
import 'package:backend/vaden_application.dart';
import 'package:test/test.dart';
import 'package:vaden/vaden.dart';

void main() {
  test('injection entity', () async {
    final app = VadenApplication();
    await app.setup();

    final dson = app.injector<DSON>();

    final json = dson.toJson(
      ProjectDTO(projectName: 'jacob', projectDescription: 'Jacob Test', dependencies: [
        DependencyDTO(name: 'openapi', version: '3.0.0', tag: 'tagg'),
        DependencyDTO(name: 'openapi2', version: '4.0.0', tag: 'tag22'),
      ]),
    );
  });
}
