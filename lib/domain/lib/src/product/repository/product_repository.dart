import 'package:domain/src/product/entity/product.dart';

abstract class ProductRepository {
  /// Busca productos. page empieza en 1.
  Future<List<Product>> searchProducts({
    required String query,
    int page = 1,
  });
}