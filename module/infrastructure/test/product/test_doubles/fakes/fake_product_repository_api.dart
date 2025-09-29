import 'package:domain/domain.dart';
import 'package:infrastructure/src/product/product_repository_api.dart';

class FakeProductRepositoryApi implements ProductRepositoryApi {
  final List<Product> productsToReturn;
  int calls = 0;

  FakeProductRepositoryApi(this.productsToReturn);

  @override
  get api => throw UnimplementedError();

  @override
  get translator => throw UnimplementedError();

  @override
  Future<List<Product>> fetchProducts({required String query, int page = 1}) async {
    calls += 1;
    return productsToReturn;
  }
}

