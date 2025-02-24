import 'dart:async';

import 'package:shelf_static/shelf_static.dart';
import 'package:vaden/vaden.dart';

class ResourceService {
  final String fileSystemPath;
  final String defaultDocument;
  final bool listDirectories;
  final bool useHeaderBytesForContentType;

  ResourceService({
    required this.fileSystemPath,
    required this.defaultDocument,
    this.listDirectories = false,
    this.useHeaderBytesForContentType = false,
  });

  FutureOr<Response> call(Request request) {
    return createStaticHandler(
      fileSystemPath,
      defaultDocument: defaultDocument,
      listDirectories: listDirectories,
      useHeaderBytesForContentType: useHeaderBytesForContentType,
    ).call(request);
  }
}
