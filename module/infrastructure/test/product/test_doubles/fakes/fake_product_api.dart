import 'package:dio/dio.dart';

class FakeProductApi {
  final Dio dio;
  FakeProductApi(this.dio);

  Future<List<Map<String, dynamic>>> searchRaw(String query, int page) async {
    final url = '/s/search/v1/soco/';
    final response = await dio.get(url, queryParameters: {
      'priceGroup': 10,
      'q': query,
      'currentpage': page,
    });

    final data = response.data;
    final results = (data['data']?['results'] as List?) ?? [];
    return results.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
