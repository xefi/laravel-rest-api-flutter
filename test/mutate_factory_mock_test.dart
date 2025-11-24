import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_mutate_body.dart';
import 'package:laravel_rest_api_flutter/data/core/rest_api_factories/laravel_rest_api/laravel_rest_api_mutate_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'mock/item_model.dart';
import 'mock/mock_http_client.dart';
import 'mock/mock_http_client.mocks.dart';

class ItemRepository with MutateFactory {
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

  group('Mutate Factory Tests', () {
    test('[200] Successful API call with valid JSON', () async {
      when(
        mockDio.post(
          '/items/mutate',
          data: {
            "mutate": [
              {
                "operation": "create",
                "attributes": ItemModel(id: 1, name: "name").toJson(),
              },
            ],
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {
            "created": [1],
            "updated": [],
          },
        ),
      );

      final result = await ItemRepository(mockDio).mutate(
        body: LaravelRestApiMutateBody(
          mutate: [
            Mutation(
              operation: MutationOperation.create,
              attributes: ItemModel(id: 1, name: "name").toJson(),
            ),
          ],
        ),
      );

      expect(result.statusCode, 200);
      expect(result.data, isNotNull);
      expect(result.data?.created.contains(1), true);
      expect(result.data?.updated.isEmpty, true);
    });

    test('[500] With common laravel error message', () async {
      when(
        mockDio.post(
          '/items/mutate',
          data: {
            "mutate": [
              {
                "operation": "create",
                "attributes": ItemModel(id: 1, name: "name").toJson(),
              },
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

      final result = await ItemRepository(mockDio).mutate(
        body: LaravelRestApiMutateBody(
          mutate: [
            Mutation(
              operation: MutationOperation.create,
              attributes: ItemModel(id: 1, name: "name").toJson(),
            ),
          ],
        ),
      );

      expect(result.statusCode, 500);
      expect(result.message, "Server error");
    });
  });

  group('Mutate complex .ToJson() tests', () {
    test('Mutation update existing item without relation', () async {
      final ItemModel item = ItemModel(id: 1, name: "new item name !");

      final result =
          LaravelRestApiMutateBody(
            mutate: [
              Mutation(
                key: item.id,
                withoutDetaching: true,
                operation: MutationOperation.update,
                attributes: item.toJson(),
              ),
            ],
          ).toJson();

      final mutateMap = result['mutate'].first;
      expect(mutateMap['key'], item.id);
      expect(mutateMap['without_detaching'], true);
      expect(mutateMap['operation'], MutationOperation.update.name);
      expect(mutateMap['attributes']['name'], item.name);
      expect(mutateMap['attributes']['id'], item.id);
    });

    test(
      'Mutation update existing item with two relations and a pivot',
      () async {
        final ItemModel item = ItemModel(id: 1, name: "new item");
        final ItemModel childItem = ItemModel(id: 2, name: "child");
        final ItemModel pivotItem = ItemModel(id: 3, name: "pivot");
        final ItemModel secondChildItem = ItemModel(id: 4, name: "secondchild");

        final result =
            LaravelRestApiMutateBody(
              mutate: [
                Mutation(
                  withoutDetaching: false,
                  operation: MutationOperation.create,
                  attributes: item.toJson(),
                  relations: [
                    MutationRelation(
                      table: 'item',
                      key: childItem.id,
                      withoutDetaching: false,
                      pivot: pivotItem.toJson(),
                      attributes: childItem.toJson(),
                      relationType: RelationType.singleRelation,
                      operation: MutationRelationOperation.toggle,
                    ),
                    MutationRelation(
                      table: 'item2',
                      key: secondChildItem.id,
                      attributes: secondChildItem.toJson(),
                      relationType: RelationType.multipleRelation,
                      operation: MutationRelationOperation.sync,
                    ),
                  ],
                ),
              ],
            ).toJson();

        final mutateMap = result['mutate'].first;
        expect(mutateMap['without_detaching'], false);
        expect(mutateMap['operation'], MutationOperation.create.name);
        expect(mutateMap['attributes']['name'], item.name);
        expect(mutateMap['attributes']['id'], item.id);

        final mutateChildMap = result['mutate'].first['relations']['item'];
        expect(mutateChildMap['without_detaching'], false);
        expect(mutateChildMap['key'], childItem.id);
        expect(mutateChildMap['attributes']['name'], childItem.name);
        expect(mutateChildMap['attributes']['id'], childItem.id);
        expect(mutateChildMap['pivot']['name'], pivotItem.name);
        expect(mutateChildMap['pivot']['id'], pivotItem.id);
        expect(
          mutateChildMap['operation'],
          MutationRelationOperation.toggle.name,
        );

        final mutateSecondChildMap =
            result['mutate'].first['relations']['item2'].first;
        expect(mutateSecondChildMap['key'], secondChildItem.id);
        expect(
          mutateSecondChildMap['attributes']['name'],
          secondChildItem.name,
        );
        expect(mutateSecondChildMap['attributes']['id'], secondChildItem.id);
        expect(
          mutateSecondChildMap['operation'],
          MutationRelationOperation.sync.name,
        );
      },
    );
  });

  test('[500] With custom object error message returned', () async {
    when(
      mockDio.post(
        '/items/mutate',
        data: {
          "mutate": [
            {
              "operation": "create",
              "attributes": ItemModel(id: 1, name: "name").toJson(),
            },
          ],
        },
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        statusCode: 500,
        data: {"error": "error"},
      ),
    );

    final result = await ItemRepository(mockDio).mutate(
      body: LaravelRestApiMutateBody(
        mutate: [
          Mutation(
            operation: MutationOperation.create,
            attributes: ItemModel(id: 1, name: "name").toJson(),
          ),
        ],
      ),
    );

    expect(result.statusCode, 500);
    expect(result.body["error"], "error");
  });
}
