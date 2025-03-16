import 'dart:async';

import 'package:vaden/vaden.dart';

@Controller('/resource')
class ResourceController {
  final ResourceService resource;
  final Storage storage;

  const ResourceController(this.resource, this.storage);

  @Mount('/public')
  FutureOr<Response> getResources(Request request) {
    return resource.call(request);
  }

  @Get('/uploads/<filename>')
  FutureOr<Response> getUploads(
    Request request,
    @Param('path') String path,
    @Query('filename') String? filename,
  ) async {
    final bytes = await storage.download(path);
    final mimetype = storage.getMimeType(path);

    return Response.ok(
      bytes,
      headers: {
        'Content-Type': mimetype,
        'Content-Disposition': 'attachment; filename="${filename ?? path}.zip"',
      },
    );
  }
}
