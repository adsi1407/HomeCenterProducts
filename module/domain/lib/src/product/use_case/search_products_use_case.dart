import 'package:domain/src/product/entity/product.dart';
import 'package:domain/src/product/repository/product_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchProductsUseCase {
  final ProductRepository _productRepository;

  SearchProductsUseCase(this._productRepository);

  Future<List<Product>> call(String query, int page) async {
    return await _productRepository.searchProducts(query: query, page: page);
  }
}