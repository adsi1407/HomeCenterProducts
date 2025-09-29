import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/product/product_cache.dart';
import 'package:infrastructure/src/product/product_repository_proxy.dart';

import 'test_doubles/fakes/fake_product_repository_api.dart';

void main() {
  group('ProductRepositoryProxy (cache-first)', () {
    test('searchProducts | cache hit | returns cached products without calling API', () async {
      // Arrange
      final cached = [Product(id: 'p1', name: 'Cached Product')];
      final api = FakeProductRepositoryApi([Product(id: 'p1', name: 'From API')]);
      final cache = ProductCache();
      final proxy = ProductRepositoryProxy(api as dynamic, cache);

      // Pre-populate cache using proxy's key convention
      final key = 'query|p:1';
      cache.set<Product>(key, cached);

      // Act
      final res = await proxy.searchProducts(query: 'query', page: 1);

      // Assert
      expect(res, equals(cached));
      expect(api.calls, 0);
    });

    test('searchProducts | cache miss | calls API and caches results', () async {
      // Arrange
      final apiProducts = [Product(id: 'p2', name: 'API Product')];
      final api = FakeProductRepositoryApi(apiProducts);
      final cache = ProductCache();
      final proxy = ProductRepositoryProxy(api as dynamic, cache);

      // Act
      final res = await proxy.searchProducts(query: 'q2', page: 1);

      // Assert
      expect(res, equals(apiProducts));
      // API should be called once
      expect(api.calls, 1);

      // Verify cached
      final key = 'q2|p:1';
      final cached = cache.get<Product>(key);
      expect(cached, equals(apiProducts));
    });

    test('searchProducts | no cache in place | behaves like cache miss', () async {
      // Arrange
      final apiProducts = [Product(id: 'p3', name: 'Third')];
      final api = FakeProductRepositoryApi(apiProducts);
      final cache = ProductCache();
      final proxy = ProductRepositoryProxy(api as dynamic, cache);

      // Ensure cache empty
      cache.clear();

      // Act
      final res = await proxy.searchProducts(query: 'no-cache', page: 1);

      // Assert
      expect(res, equals(apiProducts));
      expect(api.calls, 1);
    });
  });
}
