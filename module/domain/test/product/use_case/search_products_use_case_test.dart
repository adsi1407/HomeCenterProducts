import 'package:flutter_test/flutter_test.dart';
import 'package:domain/src/product/use_case/search_products_use_case.dart';
import 'package:domain/src/product/entity/product.dart';
import '../../fakes/fakes.dart';

// Removed the local fake repository implementation

void main() {
  group('SearchProductsUseCase', () {
    test('call | valid query & page | returns products list', () async {
      // Arrange
      final repo = FakeProductRepository(({required String query, int page = 1}) async {
        return [const Product(id: '1', name: 'Drill', price: 10.0, imageUrl: null)];
      });
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
      final repo = FakeProductRepository(({required String query, int page = 1}) async {
        throw Exception('network');
      });
      final useCase = SearchProductsUseCase(repo);

      // Act & Assert
      expect(() async => await useCase.call('x', 1), throwsA(isA<Exception>()));
    });

    test('call | empty result | returns empty list', () async {
      // Arrange
      final repo = FakeProductRepository(({required String query, int page = 1}) async {
        return <Product>[];
      });
      final useCase = SearchProductsUseCase(repo);

      // Act
      final result = await useCase.call('nothing', 1);

      // Assert
      expect(result, isEmpty);
    });
    
    test('call | page boundary values delegated to repository', () async {
      // Ensure negative/zero page parameters are passed to repository and handled there
      var captured = <Map<String, dynamic>>[];
      final repo = FakeProductRepository(({required String query, int page = 1}) async {
        captured.add({'query': query, 'page': page});
        return <Product>[];
      });
      final useCase = SearchProductsUseCase(repo);

      await useCase.call('q', 0);
      await useCase.call('q', -1);

      expect(captured.length, 2);
      expect(captured[0]['page'], 0);
      expect(captured[1]['page'], -1);
    });

    test('call | long query | returns empty list (no match)', () async {
      final repo = FakeProductRepository(({required String query, int page = 1}) async {
        return <Product>[];
      });
      final useCase = SearchProductsUseCase(repo);

      final result = await useCase.call('this-is-a-very-long-query-that-should-not-match-anything', 1);
      expect(result, isEmpty);
    });
  });
}
