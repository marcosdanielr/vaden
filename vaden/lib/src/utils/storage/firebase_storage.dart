part of 'storage.dart';

class FirebaseStorage extends Storage {
  final String projectId;
  final String apiKey;

  FirebaseStorage({
    required this.projectId,
    required this.apiKey,
  });

  @override
  Future<void> delete(String filePath) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<int>> download(String filePath) {
    // TODO: implement download
    throw UnimplementedError();
  }

  @override
  Future<List<String>> listFiles(String folder) {
    // TODO: implement listFiles
    throw UnimplementedError();
  }

  @override
  Future<String> upload(String filePath, List<int> bytes) {
    // TODO: implement upload
    throw UnimplementedError();
  }
}
