import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class FakeDioFactory {
  static Dio create({required String baseUrl, CacheOptions? cacheOptions}) {
    final store = MemCacheStore();

    final options = cacheOptions ?? CacheOptions(
      store: store,
      policy: CachePolicy.request, // keep request as default but interceptor respects cache headers
      hitCacheOnNetworkFailure: true,
      maxStale: const Duration(minutes: 30),
    );

    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    dio.interceptors.add(DioCacheInterceptor(options: options));
    return dio;
  }
}
