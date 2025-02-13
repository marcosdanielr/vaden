part of 'storage.dart';
// Import da sua classe abstrata Storage
// import 'package:seu_projeto/storage.dart';

class AwsS3Storage extends Storage {
  final String bucket;
  final String region;
  final String accessKey;
  final String secretKey;

  AwsS3Storage({
    required this.bucket,
    required this.region,
    required this.accessKey,
    required this.secretKey,
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
