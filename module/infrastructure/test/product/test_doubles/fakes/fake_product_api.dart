import 'package:dio/dio.dart';

class FakeProductApi {
  final Dio dio;
  final Map<String, List<Map<String, dynamic>>> _cache = {};

  FakeProductApi(this.dio);

  Future<List<Map<String, dynamic>>> searchRaw(String query, int page) async {
    final key = '$query|$page';
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final url = '/s/search/v1/soco/';
    final response = await dio.get(url, queryParameters: {
      'priceGroup': 10,
      'q': query,
      'currentpage': page,
    });

    final data = response.data;
    final results = (data['data']?['results'] as List?) ?? [];
    final mapped = results.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    _cache[key] = mapped;
    return mapped;
  }
}
