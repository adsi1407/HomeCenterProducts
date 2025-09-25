import 'package:domain/domain.dart';
import 'package:infrastructure/src/product/product_api.dart';
import 'package:infrastructure/src/product/product_translator.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductRepositoryApi {
  final ProductApi api;
  final ProductTranslator translator;

  ProductRepositoryApi(this.api, this.translator);

  /// Exponemos un método que devuelve domain.Product; NO registramos
  /// esta clase directamente como ProductRepository para permitir el Proxy.
  Future<List<Product>> fetchProducts({
    required String query,
    int page = 1,
  }) async {
    final raw = await api.searchRaw(query, page);
    final dtos = raw.map((m) => translator.fromApiJsonToDto(m)).toList();
    final domain = dtos.map((d) => translator.dtoToDomain(d)).toList();
    return domain;
  }
}