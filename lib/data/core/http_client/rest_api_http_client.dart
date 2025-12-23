abstract class RestApiClient {
  Future<RestApiResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });
  Future<RestApiResponse> post(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    Object? body,
    String? contentType,
  });
  Future<RestApiResponse> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    Object? body,
  });
  RestApiResponse handleError(dynamic exception, StackTrace stackTrace);
}

class RestApiResponse<T> {
  final int? statusCode;
  final Map<String, String>? headers;
  final dynamic body;
  final T? data;
  String? message;

  RestApiResponse({
    this.statusCode = 200,
    this.headers,
    this.body,
    this.data,
    this.message,
  });
}
