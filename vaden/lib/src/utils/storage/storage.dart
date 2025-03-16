import 'dart:io';

import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'package:vaden/vaden.dart';

part 'aws_s3_storage.dart';
part 'firebase_storage.dart';
part 'local_storage.dart';

abstract class Storage {
  Future<String> upload(String filePath, List<int> bytes);
  Future<List<int>> download(String filePath);
  Future<void> delete(String filePath);
  Future<List<String>> listFiles(String folder);

  static Storage createStorageService(ApplicationSettings settings) {
    switch (settings['storage']['provider']) {
      case 's3':
        return AwsS3Storage(
          bucket: settings['storage']['provider']['s3']['bucket'],
          region: settings['storage']['provider']['s3']['region'],
          accessKey: settings['storage']['provider']['s3']['accessKey'],
          secretKey: settings['storage']['provider']['s3']['secretKey'],
        );
      case 'firebase':
        return FirebaseStorage(
          projectId: settings['storage']['provider']['firebase']['projectId'],
          apiKey: settings['storage']['provider']['firebase']['apiKey'],
        );
      case 'local':
      default:
        return LocalStorage(settings['storage']['provider']);
    }
  }

  String getMimeType(String filePath) {
    return lookupMimeType(filePath) ?? 'application/octet-stream';
  }
}
