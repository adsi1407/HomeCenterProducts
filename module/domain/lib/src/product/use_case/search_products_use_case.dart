import 'package:domain/src/product/entity/product.dart';
import 'package:domain/src/product/repository/product_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchProductsUseCase {
  final ProductRepository _productRepository;
  final int _page;

  SearchProductsUseCase(this._productRepository, this._page);

  Future<List<Product>> call(String query, int page) {
    return _productRepository.searchProducts(query: query, page: _page);
  }
}