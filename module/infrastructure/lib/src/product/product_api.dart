import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProductApi {
  final Dio dio;
  ProductApi(this.dio);

  /// Retorna la lista cruda de resultados (List<dynamic> de objetos JSON).
  Future<List<Map<String, dynamic>>> searchRaw(String query, int page) async {
    final url = 'https://www.homecenter.com.co/s/search/v1/soco/';
    final response = await dio.get(url, queryParameters: {
      'priceGroup': 10,
      'q': query,
      'currentpage': page,
    });

    final data = response.data;
    final results = (data['data']?['results'] as List?) ?? [];
    // Normalizamos al tipo List<Map<String,dynamic>>
    return results.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}