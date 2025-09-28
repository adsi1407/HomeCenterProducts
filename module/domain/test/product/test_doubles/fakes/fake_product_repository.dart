import 'package:domain/src/product/entity/product.dart';
import 'package:domain/src/product/repository/product_repository.dart';

class FakeProductRepository implements ProductRepository {
  final Future<List<Product>> Function({required String query, int page}) _handler;
  FakeProductRepository(this._handler);

  @override
  Future<List<Product>> searchProducts({required String query, int page = 1}) {
    return _handler(query: query, page: page);
  }
}
