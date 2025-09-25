import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';

@module
abstract class InfrastructureModule {
  /// Dio pre-resuelto: crea Dio con interceptor de cache en memoria.
  @preResolve
  Future<Dio> dio() async {
    final store = MemCacheStore(); // cache sólo en memoria, no persiste en disco

    final cacheOptions = CacheOptions(
      store: store,
      policy: CachePolicy.request,              // devuelve cache si existe; si no va a red
      hitCacheOnErrorCodes: const [401, 403],   // códigos donde no queremos devolver cache por error (ajusta)
      hitCacheOnNetworkFailure: true,           // si no hay red devuelve caché si existe
      maxStale: const Duration(minutes: 30),    // tiempo máximo que aceptamos entradas stale
      priority: CachePriority.normal,
    );

    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));
    
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    return dio;
  }
}