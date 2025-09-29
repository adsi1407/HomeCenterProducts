import 'package:mocktail/mocktail.dart';
import 'package:domain/src/product/entity/product.dart';
import 'package:domain/src/product/repository/product_repository.dart';

class MockProductRepository extends Mock implements ProductRepository {}

MockProductRepository makeProductRepoMockWithResults(List<Product> results) {
  final mock = MockProductRepository();
  when(() => mock.searchProducts(query: any(named: 'query'), page: any(named: 'page')))
      .thenAnswer((_) async => results);
  return mock;
}

MockProductRepository makeProductRepoMockThrow(Object error) {
  final mock = MockProductRepository();
  when(() => mock.searchProducts(query: any(named: 'query'), page: any(named: 'page')))
      .thenThrow(error);
  return mock;
}
