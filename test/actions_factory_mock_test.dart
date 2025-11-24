import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_actions_body.dart';
import 'package:laravel_rest_api_flutter/data/core/rest_api_factories/laravel_rest_api/laravel_rest_api_actions_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'mock/mock_http_client.dart';
import 'mock/mock_http_client.mocks.dart';

class ItemRepository with ActionsFactory {
  MockDio mockDio;
  ItemRepository(this.mockDio);

  @override
  String get baseRoute => '/items';

  @override
  RestApiClient get httpClient => MockApiHttpClient(dio: mockDio);
}

void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
  });

  group('Action Factory Tests', () {
    test('[200] Successful API call with valid JSON', () async {
      when(
        mockDio.post(
          '/items',
          data: {
            "fields": [
              {"name": "expires_at", "value": "2023-04-29"},
            ],
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {
            "data": {"impacted": 10},
          },
        ),
      );

      final result = await ItemRepository(mockDio).actions(
        data: LaravelRestApiActionsBody(
          fields: [Action(name: "expires_at", value: "2023-04-29")],
        ),
      );

      expect(result.data, 10);
    });

    test('[500] With common laravel error message', () async {
      when(
        mockDio.post(
          '/items',
          data: {
            "fields": [
              {"name": "expires_at", "value": "2023-04-29"},
            ],
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 500,
          data: {
            "message": "Server error",
            "exception":
                "Symfony\\Component\\HttpKernel\\Exception\\NotFoundHttpException",
            "file":
                "/path/to/project/vendor/symfony/http-kernel/Exception/NotFoundHttpException.php",
            "line": 23,
          },
        ),
      );

      final result = await ItemRepository(mockDio).actions(
        data: LaravelRestApiActionsBody(
          fields: [Action(name: "expires_at", value: "2023-04-29")],
        ),
      );

      expect(result.statusCode, 500);
      expect(result.message, "Server error");
    });
  });
}
