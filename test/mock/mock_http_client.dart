import 'package:dio/dio.dart';
import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Dio])
class MockApiHttpClient implements RestApiClient {
  final Dio dio;

  MockApiHttpClient({required this.dio});

  @override
  Future<RestApiResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final response = await dio.get(
        url,
        options: Options(headers: headers),
        queryParameters: queryParams,
      );
      return RestApiResponse(
        statusCode: response.statusCode ?? 500,
        body: response.data,
      );
    } catch (exception, stackTrace) {
      return handleError(exception, stackTrace);
    }
  }

  @override
  Future<RestApiResponse> post(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    Object? body,
    String? contentType,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: body,
        options: Options(contentType: contentType),
      );
      return RestApiResponse(
        statusCode: response.statusCode ?? 500,
        body: response.data,
      );
    } catch (exception, stackTrace) {
      return handleError(exception, stackTrace);
    }
  }

  @override
  Future<RestApiResponse> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    Object? body,
  }) async {
    try {
      final response = await dio.delete(url, data: body);
      return RestApiResponse(
        statusCode: response.statusCode,
        body: response.data,
      );
    } catch (exception, stackTrace) {
      return handleError(exception, stackTrace);
    }
  }

  @override
  RestApiResponse handleError(dynamic exception, StackTrace stackTrace) {
    if (exception is DioException) {
      return RestApiResponse(
        statusCode: exception.response?.statusCode,
        body: exception.response?.data ?? {'error': exception.message},
      );
    }
    return RestApiResponse(statusCode: 500, body: {'error': exception});
  }
}
