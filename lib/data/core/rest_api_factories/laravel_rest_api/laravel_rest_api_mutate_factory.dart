import 'package:dio/dio.dart';
import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_mutate_body.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/response/laravel_rest_api_mutate_reponse.dart';
import '../../rest_api_repository.dart';

/// A mixin to simplify building search requests for Laravel Rest API.
mixin MutateFactory {
  /// The base route for the resource (e.g., '/posts').
  String get baseRoute;

  /// The HTTP client used to send requests. Typically a http or Dio instance.
  RestApiClient get httpClient;

  Future<RestApiResponse<LaravelRestApiMutateResponse>> mutate({
    required LaravelRestApiMutateBody body,
    Map<String, String>? headers,
  }) async {
    return _mutateInternal(body: body.toJson(), headers: headers);
  }

  /// Multipart mutate (files upload)
  Future<RestApiResponse<LaravelRestApiMutateResponse>> mutateMultipart({
    required FormData formData,
    Map<String, String>? headers,
  }) async {
    return _mutateInternal(
      body: formData,
      headers: headers,
      contentType: 'multipart/form-data',
    );
  }

  Future<RestApiResponse<LaravelRestApiMutateResponse>> _mutateInternal({
    required Object body,
    Map<String, String>? headers,
    String? contentType,
  }) async {
    final response = await handlingResponse(
      '$baseRoute/mutate',
      headers: headers,
      apiMethod: ApiMethod.post,
      client: httpClient,
      body: body,
      contentType: contentType,
    );

    if (response.body is Map &&
        response.body.containsKey("created") &&
        response.body.containsKey("updated")) {
      return RestApiResponse<LaravelRestApiMutateResponse>(
        body: response.body,
        data: LaravelRestApiMutateResponse(
          created: response.body["created"],
          updated: response.body["updated"],
        ),
        message: response.message,
        headers: response.headers,
        statusCode: response.statusCode,
      );
    }

    return RestApiResponse<LaravelRestApiMutateResponse>(
      body: response.body,
      headers: response.headers,
      message: response.message,
      statusCode: response.statusCode,
    );
  }
}
