import 'package:domain/domain.dart';
import 'package:infrastructure/src/product/product_cache.dart';
import 'package:infrastructure/src/product/product_repository_api.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductRepository)
class ProductRepositoryProxy implements ProductRepository {
  final ProductRepositoryApi _productRepositoryApi;
  final ProductCache _cache;

  ProductRepositoryProxy(this._productRepositoryApi, this._cache);

  String _key(String q, int page) => '$q|p:$page';

  @override
  Future<List<Product>> searchProducts({required String query, int page = 1}) async {
    final key = _key(query, page);

    // Política: cache-first (si hay, devolver), si no, consultar y cachear.
    final cached = _cache.get<Product>(key);
    if (cached != null) {
      return cached;
    }

    // No hay cache: delega al implementación de la API y guarda resultados
    final fresh = await _productRepositoryApi.fetchProducts(query: query, page: page);
    _cache.set<Product>(key, fresh);
    return fresh;
  }
}