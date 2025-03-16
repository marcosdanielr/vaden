part of 'storage.dart';

class LocalStorage extends Storage {
  final String folderPath;

  LocalStorage(this.folderPath);

  @override
  Future<String> upload(String filePath, List<int> bytes) async {
    final extension = _extractExtension(filePath);
    final uniqueName = '${Uuid().v4()}.$extension';

    final file = File('$folderPath/$uniqueName');
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);
    return uniqueName;
  }

  @override
  Future<List<int>> download(String filePath) async {
    final file = File('$folderPath/$filePath');
    if (await file.exists()) {
      return file.readAsBytes();
    }
    throw Exception('File not found: $filePath');
  }

  @override
  Future<void> delete(String filePath) async {
    final file = File('$folderPath/$filePath');
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<List<String>> listFiles([String? folder]) async {
    final directory = Directory(folder == null ? folderPath : '$folderPath/$folder');
    if (!await directory.exists()) {
      return [];
    }

    final items = await directory.list().toList();
    final filePaths = <String>[];
    for (final entity in items) {
      if (entity is File) {
        final relativePath = entity.path.replaceFirst('$folderPath/', '');
        filePaths.add(relativePath);
      }
    }
    return filePaths;
  }

  String _extractExtension(String filePath) {
    // Ex: se filePath = "example.png", retorna "png"
    final dotIndex = filePath.lastIndexOf('.');
    return (dotIndex == -1) ? '' : filePath.substring(dotIndex + 1);
  }
}
