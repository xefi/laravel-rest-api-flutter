import 'package:laravel_rest_api_flutter/data/core/constants.dart';
import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_search_body.dart';

import '../../rest_api_repository.dart';

/// A mixin to simplify building search requests for Laravel Rest API.
mixin SearchFactory<T> {
  /// The base route for the resource (e.g., '/posts').
  String get baseRoute;

  /// The HTTP client used to send requests. Typically a Dio instance.
  RestApiClient get httpClient;

  /// Default request body for search requests, if any.
  /// Can include predefined filters, scopes, or other configurations.
  LaravelRestApiSearchBody? get defaultSearchBody => null;

  /// Converts a JSON response into an instance of type `T`.
  T fromJson(Map<String, dynamic> json);

  /// Execute when exception is catched
  void onCatchError(
    RestApiResponse? response,
    Object exception,
    StackTrace stacktrace,
  );

  /// Performs a search request and returns a list of items of type `T`.
  Future<RestApiResponse<List<T>>> search({
    /// **Text Search**: Allows for full-text search on enabled resources.
    /// Use the `text` parameter with a `value` containing your search terms.
    TextSearch? text,

    /// **Scopes**: Allows for scoped queries defined in your Laravel resource.
    /// Specify the scope name and its parameters.
    List<Scope>? scopes,

    /// **Filters**: Specify the data you want to retrieve based on defined fields.
    /// Fields must be predefined in the Laravel resource.
    List<Filter>? filters,

    /// **Sorts**: Specify the order in which results should be returned.
    /// Sorting fields must be predefined in the Laravel resource.
    List<Sort>? sorts,

    /// **Selects**: Specify which columns to select for faster queries.
    /// Only predefined fields in the Laravel resource can be selected.
    List<Select>? selects,

    /// **Includes**: Query relationships directly through a single endpoint.
    /// Define the relation name, filters, and limits for inclusion.
    List<Include>? includes,

    /// **Aggregates**: Use aggregates like `max`, `min`, `count`, etc.
    /// Aggregates operate on relationships or fields in the Laravel resource.
    List<Aggregate>? aggregates,

    /// **Instructions**: Define strong query operations defined in the Laravel resource.
    List<Instruction>? instructions,

    /// **Pagination**: Specify the page number for paginated results.
    int? page,

    /// **Pagination Limit**: Specify the maximum number of results per page.
    int? limit,

    ///Request header
    Map<String, String>? headers,
  }) async {
    RestApiResponse? response;
    try {
      // Building the request body with defaults and overrides.
      final requestBody = {
        "search": {
          ...?defaultSearchBody?.toJson(),
          if (text != null) 'text': text.toJson(),
          if (scopes != null) 'scopes': scopes.map((e) => e.toJson()).toList(),
          if (filters != null)
            'filters': filters.map((e) => e.toJson()).toList(),
          if (sorts != null) 'sorts': sorts.map((e) => e.toJson()).toList(),
          if (selects != null)
            'selects': selects.map((e) => e.toJson()).toList(),
          if (includes != null)
            'includes': includes.map((e) => e.toJson()).toList(),
          if (aggregates != null)
            'aggregates': aggregates.map((e) => e.toJson()).toList(),
          if (instructions != null)
            'instructions': instructions.map((e) => e.toJson()).toList(),
          if (limit != null) 'limit': limit,
          if (instructions != null) 'page': page,
        },
      };

      // Sending the request using a REST API client.
      response = await handlingResponse(
        '$baseRoute/search',
        headers: headers,
        apiMethod: ApiMethod.post,
        client: httpClient,
        body: requestBody["search"]!.isEmpty ? null : requestBody,
      );

      if (!successStatus.contains(response.statusCode)) {
        String message =
            "Api call return a failed status: ${response.statusCode}";
        if (response.body is Map && response.body.containsKey("message")) {
          message = response.body["message"];
        }
        return RestApiResponse<List<T>>(
          body: response.body,
          message: message,
          statusCode: response.statusCode,
        );
      }
    } catch (exception, stacktrace) {
      onCatchError(response, exception, stacktrace);
      return RestApiResponse<List<T>>(
        body: response?.body,
        message: "Dart exception during api call: $stacktrace",
        statusCode: response?.statusCode,
      );
    }
    try {
      final items = (response.body?['data'] as List<dynamic>)
          .map<T>((item) => fromJson(item))
          .toList();
      return RestApiResponse<List<T>>(
        data: items,
        body: response.body,
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (exception, stacktrace) {
      onCatchError(response, exception, stacktrace);
      return RestApiResponse<List<T>>(
        body: response.body,
        message: "Json model deserialize failed: $stacktrace",
        statusCode: response.statusCode,
      );
    }
  }
}
