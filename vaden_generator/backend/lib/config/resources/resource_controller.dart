import 'dart:async';
import 'dart:convert';

import 'package:vaden/vaden.dart';

@Api(tag: 'resource')
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
    @Param() String filename,
    @Query() String? name,
  ) async {
    final bytes = await storage.download(filename);
    final mimetype = storage.getMimeType(filename);

    return Response.ok(
      bytes,
      headers: {
        'Content-Type': mimetype,
        'Content-Disposition': 'attachment; filename="${name ?? filename}"',
      },
    );
  }

  @Post('/uploads')
  FutureOr<Response> uploadFile(Request request) async {
    if (request.multipart() case var multipart?) {
      final links = <Map<String, String>>[];
      await for (final part in multipart.parts) {
        final headers = part.headers;
        final fileName = headers['content-disposition']!.split('filename=')[1].trim();
        final link = await storage.upload(fileName, await part.readBytes());
        links.add({'filename': fileName, 'link': link});
      }

      return Response.ok(jsonEncode({'message': 'File uploaded'}));
    }
    return Response(400, body: jsonEncode({'error': 'No file uploaded'}));
  }
}
