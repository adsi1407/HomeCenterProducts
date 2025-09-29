import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:infrastructure/src/product/product_repository_api.dart';
import 'package:infrastructure/src/product/product_api.dart';
import 'package:infrastructure/src/product/product_translator.dart';
import 'package:domain/domain.dart';

class FakeApi implements ProductApi {
  final List<Map<String, dynamic>> data;
  FakeApi(this.data);

  @override
  Future<List<Map<String, dynamic>>> searchRaw(String query, int page) async {
    return data;
  }

  // Not used in tests but required by interface
  @override
  // satisfy interface - not used in tests
  final Dio dio = Dio();
}

void main() {
  group('ProductRepositoryApi', () {
    test('fetchProducts delegates to api and translator', () async {
      final api = FakeApi([
        {'id': '1', 'name': 'n'},
      ]);
      final translator = ProductTranslator();
      final repo = ProductRepositoryApi(api, translator);

      final res = await repo.fetchProducts(query: 'q', page: 1);
      expect(res, isA<List<Product>>());
      expect(res.first.id, '1');
    });
  });
}
