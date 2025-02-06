class Response {
  final int statusCode;
  final dynamic body;

  const Response(this.statusCode, this.body);

  Response.ok([dynamic body]) : this(200, body);

  Response.created([dynamic body]) : this(201, body);

  Response.noContent() : this(204, null);

  Response.notFound([dynamic body]) : this(404, body);

  Response.internalServerError([dynamic body]) : this(500, body);

  Response.badRequest([dynamic body]) : this(400, body);

  Response.unauthorized([dynamic body]) : this(401, body);

  Response.forbidden([dynamic body]) : this(403, body);

  Response.conflict([dynamic body]) : this(409, body);

  Response.unprocessableEntity([dynamic body]) : this(422, body);
}
