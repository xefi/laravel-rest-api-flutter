import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_search_body.dart';
import 'package:laravel_rest_api_flutter/data/core/rest_api_factories/laravel_rest_api/laravel_rest_api_search_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import '../mock/item_model.dart';
import '../mock/mock_http_client.dart';
import '../mock/mock_http_client.mocks.dart';

class ItemRepository with SearchFactory<ItemModel> {
  MockDio mockDio;
  ItemRepository(this.mockDio);

  @override
  String get baseRoute => '/items';

  @override
  RestApiClient get httpClient => MockApiHttpClient(dio: mockDio);

  @override
  ItemModel fromJson(Map<String, dynamic> item) => ItemModel.fromJson(item);

  @override
  void onCatchError(
    RestApiResponse? response,
    Object exception,
    StackTrace stacktrace,
  ) {}
}

class ItemRepositoryWithDefaultBody with SearchFactory<ItemModel> {
  MockDio mockDio;
  ItemRepositoryWithDefaultBody(this.mockDio);

  @override
  String get baseRoute => '/items';

  @override
  RestApiClient get httpClient => MockApiHttpClient(dio: mockDio);

  @override
  LaravelRestApiSearchBody? get defaultSearchBody => LaravelRestApiSearchBody(
    filters: [Filter(field: "field", operator: "operator", value: "value")],
  );

  @override
  ItemModel fromJson(Map<String, dynamic> item) => ItemModel.fromJson(item);

  @override
  void onCatchError(
    RestApiResponse? response,
    Object exception,
    StackTrace stacktrace,
  ) {}
}

void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
  });

  group('Search Factory Tests', () {
    test('[200] Successful API call with valid JSON', () async {
      when(mockDio.post('/items/search')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {
            'data': [
              {'id': 1, 'name': 'Lou West'},
              {'id': 2, 'name': 'Bridget Wilderman'},
            ],
          },
        ),
      );

      final result = await ItemRepository(mockDio).search();

      expect(result.statusCode, 200);
      expect(result.data, isNotNull);
    });

    test('[200] Successful API call with bad JSON', () async {
      when(mockDio.post('/items/search')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {
            'data': [
              {'idd': 1, 'name': 'Lou West'},
              {'idd': 2, 'name': 'Bridget Wilderman'},
            ],
          },
        ),
      );

      final result = await ItemRepository(mockDio).search();

      expect(result.statusCode, 200);
      expect(result.data, isNull);
    });

    test('[404] With common laravel error message', () async {
      when(mockDio.post('/items/search')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 404,
          data: {
            "message": "Not Found",
            "exception":
                "Symfony\\Component\\HttpKernel\\Exception\\NotFoundHttpException",
            "file":
                "/path/to/project/vendor/symfony/http-kernel/Exception/NotFoundHttpException.php",
            "line": 23,
          },
        ),
      );

      final result = await ItemRepository(mockDio).search();

      expect(result.statusCode, 404);
      expect(result.message, "Not Found");
    });
  });
  test('[500] With custom object error message returned', () async {
    when(mockDio.post('/items/search')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        statusCode: 500,
        data: {"error": "error"},
      ),
    );

    final result = await ItemRepository(mockDio).search();

    expect(result.statusCode, 500);
    expect(result.body["error"], "error");
  });

  test('[500] With custom list error message returned', () async {
    when(mockDio.post('/items/search')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        statusCode: 500,
        data: [
          {"error": "error"},
        ],
      ),
    );

    final result = await ItemRepository(mockDio).search();

    expect(result.statusCode, 500);
    expect(result.body[0]["error"], "error");
  });

  test('Check if all attributes filter can be send in body', () async {
    when(mockDio.post('/items/search', data: anyNamed('data'))).thenAnswer(
      (_) async => Response(requestOptions: RequestOptions(), statusCode: 200),
    );

    await ItemRepositoryWithDefaultBody(mockDio).search(
      text: TextSearch(value: "my text search"),
      filters: [Filter(field: "field", type: "type")],
      aggregates: [
        Aggregate(relation: "relation", type: "type", field: "field"),
      ],
      includes: [
        Include(
          relation: "relation",
          includes: [Include(relation: "relationIncludes")],
          selects: [Select(field: "relationField")],
          filters: [Filter(field: "relationFilter")],
        ),
      ],
      instructions: [
        Instruction(
          name: "name",
          fields: [Field(name: "name", value: "value")],
        ),
      ],
      limit: 1,
      page: 1,
      scopes: [Scope(name: "name")],
      selects: [Select(field: "field")],
      sorts: [Sort(field: "field", direction: "direction")],
    );

    // Check body send to api
    final capturedArgs =
        verify(
          mockDio.post('/items/search', data: captureAnyNamed('data')),
        ).captured;

    expect(capturedArgs[0].containsKey('search'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('text'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('filters'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('aggregates'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('includes'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('instructions'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('scopes'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('selects'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('sorts'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('limit'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('page'), isTrue);
    expect(
      capturedArgs[0]["search"]["includes"][0]["includes"][0]["relation"] ==
          "relationIncludes",
      capturedArgs[0]["search"]["includes"][0]["selects"][0]["field"] ==
          "relationField",
    );
    expect(
      capturedArgs[0]["search"]["includes"][0]["filters"][0]["field"] ==
          "relationFilter",
      isTrue,
    );
  });
  test('Check if defaultSearchBody is correctly send to api', () async {
    when(mockDio.post('/items/search', data: anyNamed('data'))).thenAnswer(
      (_) async => Response(requestOptions: RequestOptions(), statusCode: 200),
    );

    await ItemRepositoryWithDefaultBody(mockDio).search(
      aggregates: [
        Aggregate(relation: "relation", type: "type", field: "field"),
      ],
    );

    // Check body send to api
    final capturedArgs =
        verify(
          mockDio.post('/items/search', data: captureAnyNamed('data')),
        ).captured;

    expect(capturedArgs[0].containsKey('search'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('filters'), isTrue);
    expect(capturedArgs[0]["search"].containsKey('aggregates'), isTrue);
  });
}
