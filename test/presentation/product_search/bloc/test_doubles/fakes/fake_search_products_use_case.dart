import 'package:domain/domain.dart';

class FakeSearchProductsUseCase implements SearchProductsUseCase {
  final List<Product> Function(String query, int page) _resolver;

  FakeSearchProductsUseCase(this._resolver);

  @override
  Future<List<Product>> call(String query, int page) async {
    return _resolver(query, page);
  }
}
