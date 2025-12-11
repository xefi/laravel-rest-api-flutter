import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import '../../rest_api_repository.dart';

/// A mixin to simplify building search requests for Laravel Rest API.
mixin DeleteFactory<T> {
  /// The base route for the resource (e.g., '/posts').
  String get baseRoute;

  /// The HTTP client used to send requests. Typically a Dio instance.
  RestApiClient get httpClient;

  /// Converts a JSON response into an instance of type `T`.
  T fromJson(Map<String, dynamic> json);

  Future<RestApiResponse<List<T>>> delete({
    required List<dynamic> resourceIds,
    Map<String, String>? headers,
  }) async {
    late RestApiResponse response;
    try {
      response = await handlingResponse(
        baseRoute,
        apiMethod: ApiMethod.delete,
        client: httpClient,
        body: {"resources": resourceIds},
      );

      final items = (response.body?['data'] as List<dynamic>)
          .map<T>((item) => fromJson(item))
          .toList();
      return RestApiResponse<List<T>>(
        statusCode: response.statusCode,
        body: response.body,
        data: items,
      );
    } catch (exception) {
      return RestApiResponse<List<T>>(
        message: response.message,
        statusCode: 500,
      );
    }
  }
}
