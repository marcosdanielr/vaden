class Request<T> {
  final String path;
  final Map<String, String> headers;
  final Map<String, String> queryParameters;
  final dynamic body;

  Request({
    required this.path,
    required this.headers,
    required this.queryParameters,
    required this.body,
  });
}
