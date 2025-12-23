import 'dart:async';
import 'package:laravel_rest_api_flutter/data/core/constants.dart';
import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';

enum ApiMethod { get, post, delete }

enum ApiResponseType { none, list, object }

Future<RestApiResponse> handlingResponse(
  String route, {
  required ApiMethod apiMethod,
  required RestApiClient client,
  dynamic body,
  Map<String, String>? queryParameters,
  Map<String, String>? headers,
  final FutureOr Function(RestApiResponse)? onSuccess,
  final FutureOr Function(Object)? onError,
  String? contentType,
  bool? isCustomResponse = false,
}) async {
  RestApiResponse? response;
  try {
    switch (apiMethod) {
      case ApiMethod.get:
        response = await client.get(route, headers: headers);
      case ApiMethod.post:
        response = await client.post(
          route,
          body: body,
          headers: headers,
          contentType: contentType,
        );
      case ApiMethod.delete:
        response = await client.delete(route, body: body, headers: headers);
    }

    if (successStatus.contains(response.statusCode)) {
      if (onSuccess != null) {
        await onSuccess(response);
      }
    } else if (response.body is Map && response.body.containsKey("message")) {
      response.message = response.body["message"];
    }

    return RestApiResponse(
      body: response.body,
      data: response.data,
      headers: response.headers,
      statusCode: response.statusCode,
      message: response.message,
    );
  } catch (exception) {
    if (onError != null) {
      await onError(exception);
    }
    return RestApiResponse(
      body: response?.body,
      statusCode: 500,
      message: exception.toString(),
    );
  }
}
