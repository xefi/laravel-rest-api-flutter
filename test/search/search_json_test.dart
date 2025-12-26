import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_search_body.dart';

void main() {
  group('Explicit Null Value (Filter & Field)', () {
    test('Filter: toJson sends explicit null for value', () {
      final filter = Filter(field: 'status', value: null);
      final json = filter.toJson();

      expect(json.containsKey('value'), isTrue);
      expect(json['value'], isNull);
    });

    test('Field: toJson sends explicit null for value', () {
      final field = InstructionField(name: 'desc', value: null);
      final json = field.toJson();

      expect(json.containsKey('value'), isTrue);
      expect(json['value'], isNull);
    });
  });

  group('Conditional Keys (Scope)', () {
    test('Scope: toJson omits parameters key if null', () {
      final scope = Scope(name: 'active');
      final json = scope.toJson();

      expect(json['name'], 'active');
      expect(json.containsKey('parameters'), isFalse);
    });
  });

  group('LaravelRestApiSearchBody', () {
    test('toJson: returns empty map when all properties are null', () {
      final body = LaravelRestApiSearchBody();
      expect(body.toJson(), isEmpty);
    });

    test('toJson: handles mix of implicit removal and explicit nulls', () {
      final body = LaravelRestApiSearchBody(
        page: 1,
        text: TextSearch(value: null),
        gates: ['admin'],
        filters: [Filter(field: 'role', value: null)],
      );

      final json = body.toJson();

      expect(json['page'], 1);
      expect(json['gates'], ['admin']);

      final filtersList = json['filters'] as List;
      expect(filtersList[0]['field'], 'role');
      expect(filtersList[0].containsKey('value'), isTrue);
      expect(filtersList[0]['value'], isNull);
    });
  });
}
