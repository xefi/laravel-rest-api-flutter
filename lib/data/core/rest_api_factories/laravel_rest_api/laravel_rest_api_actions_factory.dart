import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_actions_body.dart';
import '../../rest_api_repository.dart';

/// A mixin to simplify building search requests for Laravel Rest API.
mixin ActionsFactory {
  /// The base route for the resource (e.g., '/posts').
  String get baseRoute;

  /// The HTTP client used to send requests. Typically a Dio instance.
  RestApiClient get httpClient;

  Future<RestApiResponse<int>> actions({
    required LaravelRestApiActionsBody data,
    Map<String, String>? headers,
  }) async {
    late RestApiResponse response;
    try {
      response = await handlingResponse(
        baseRoute,
        headers: headers,
        apiMethod: ApiMethod.post,
        client: httpClient,
        body: data.toJson(),
      );
      return RestApiResponse<int>(
        statusCode: response.statusCode,
        body: response.body,
        data: response.body?['data']['impacted'] ?? 0,
      );
    } catch (exception) {
      return RestApiResponse<int>(message: response.message, statusCode: 500);
    }
  }
}
