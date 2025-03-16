import 'dart:convert';
import 'dart:io';

import 'package:backend/src/core/files/file_manager.dart';
import 'package:backend/src/data/services/generate_service_impl.dart';
import 'package:backend/src/domain/entities/dependency.dart';
import 'package:backend/src/domain/entities/project.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';
import 'package:vaden/vaden.dart';

class FileMock implements File {
  var text = '';

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  Future<List<String>> readAsLines({Encoding encoding = utf8}) async {
    return ['line 1', 'line 2', 'line 3'];
  }

  @override
  Future<File> writeAsString(
    String contents, {
    FileMode mode = FileMode.write,
    Encoding encoding = utf8,
    bool flush = false,
  }) {
    text = contents;
    return Future.value(this);
  }
}

void main() {
  final storage = LocalStorage('testing/storage');

  test('generate initial project', () async {
    final temp = Directory('testing');
    final generate = GenerateServiceImpl(FileManager(), storage);

    await generate.createTempProject(
      Project(
        dependencies: [],
        projectName: 'jacob',
        projectDescription: 'Jacob Moura',
        dartVersion: '3.0.6',
      ),
      temp,
    );
  });

  test('generate initial project with dependency', () async {
    final temp = Directory('testing');
    final generate = GenerateServiceImpl(FileManager(), storage);

    await generate
        .createTempProject(
          Project(
            dependencies: [
              Dependency(name: 'Open API', version: '3.0.0', tag: 'openapi'),
            ],
            projectName: 'jacob',
            projectDescription: 'Jacob Moura',
            dartVersion: '3.0.6',
          ),
          temp,
        )
        .flatMap(generate.addDependencies);
  });

  test('generate initial project with dependency and generate zip', () async {
    final temp = Directory('testing');
    final generate = GenerateServiceImpl(FileManager(), storage);

    final link = await generate
        .createTempProject(
          Project(
            dependencies: [
              Dependency(name: 'Open API', version: '3.0.0', tag: 'openapi'),
            ],
            projectName: 'jacob',
            projectDescription: 'Jacob Moura',
            dartVersion: '3.0.6',
          ),
          temp,
        )
        .flatMap(generate.addDependencies)
        .flatMap(generate.createZipLink)
        .getOrThrow();

    print(link.url);
  });

  test('add line before', () async {
    final manager = FileManager();
    final file = FileMock();
    final line = RegExp(r'line 2');
    final content = 'line 1.5';

    await manager.insertLineInFile(file, line, content, position: InsertLinePosition.before);

    expect(file.text, 'line 1\nline 1.5\nline 2\nline 3');
  });
  test('add line after', () async {
    final manager = FileManager();
    final file = FileMock();
    final line = RegExp(r'line 2');
    final content = 'line 2.5';

    await manager.insertLineInFile(file, line, content, position: InsertLinePosition.after);

    expect(file.text, 'line 1\nline 2\nline 2.5\nline 3');
  });
}
