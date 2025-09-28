import 'package:domain/domain.dart';

class FakeProductRepositoryApi {
  final List<Product> productsToReturn;
  int calls = 0;

  FakeProductRepositoryApi(this.productsToReturn);

  Future<List<Product>> fetchProducts({required String query, int page = 1}) async {
    calls += 1;
    return productsToReturn;
  }
}
