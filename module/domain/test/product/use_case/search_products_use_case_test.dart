import 'package:flutter_test/flutter_test.dart';
import 'package:domain/src/product/use_case/search_products_use_case.dart';
import 'package:domain/src/product/entity/product.dart';
import 'package:mocktail/mocktail.dart';

import 'test_doubles/mocks/mock_product_repository.dart';

// Removed the local fake repository implementation

void main() {
  group('SearchProductsUseCase', () {
    test('call | valid query & page | returns products list', () async {
      // Arrange
      final repo = makeProductRepoMockWithResults([
        const Product(id: '1', name: 'Drill', price: 10.0, imageUrl: null)
      ]);
      final useCase = SearchProductsUseCase(repo);

      // Act
      final result = await useCase.call('taladro', 1);

      // Assert
      expect(result, isA<List<Product>>());
      expect(result.length, 1);
      expect(result.first.name, 'Drill');
    });

    test('call | repository throws | bubble exception', () async {
      // Arrange
      final repo = makeProductRepoMockThrow(Exception('network'));
      final useCase = SearchProductsUseCase(repo);

      // Act & Assert
      expect(() async => await useCase.call('x', 1), throwsA(isA<Exception>()));
    });

    test('call | empty result | returns empty list', () async {
      // Arrange
      final repo = makeProductRepoMockWithResults(<Product>[]);
      final useCase = SearchProductsUseCase(repo);

      // Act
      final result = await useCase.call('nothing', 1);

      // Assert
      expect(result, isEmpty);
    });
    
    test('call | page boundary values delegated to repository', () async {
      // Ensure negative/zero page parameters are passed to repository and handled there
      var captured = <Map<String, dynamic>>[];
      // Use a mock to capture arguments passed to repository
      final mock = MockProductRepository();
      when(() => mock.searchProducts(query: any(named: 'query'), page: any(named: 'page')))
          .thenAnswer((inv) async {
        final q = inv.namedArguments[#query] as String;
        final p = inv.namedArguments[#page] as int;
        captured.add({'query': q, 'page': p});
        return <Product>[];
      });
      final useCase = SearchProductsUseCase(mock);

      await useCase.call('q', 0);
      await useCase.call('q', -1);

      expect(captured.length, 2);
      expect(captured[0]['page'], 0);
      expect(captured[1]['page'], -1);
    });

    test('call | long query | returns empty list (no match)', () async {
      final repo = makeProductRepoMockWithResults(<Product>[]);
      final useCase = SearchProductsUseCase(repo);

      final result = await useCase.call('this-is-a-very-long-query-that-should-not-match-anything', 1);
      expect(result, isEmpty);
    });
  });
}
