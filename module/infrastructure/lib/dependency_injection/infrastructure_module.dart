import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:infrastructure/src/cart/app_database.dart';
import 'package:infrastructure/src/cart/cart_dao.dart';

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

  /// Provide a pre-resolved AppDatabase using a NativeDatabase backed by a
  /// file in the platform documents directory. If obtaining a directory fails
  /// (for tests or environments without path_provider) fall back to an
  /// in-memory database.
  @preResolve
  Future<AppDatabase> appDatabase() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dir.path, 'home_center_products.sqlite'));
      final executor = NativeDatabase(dbFile);
      return AppDatabase(executor);
    } catch (_) {
      // Fallback for test environments: memory database
      final executor = NativeDatabase.memory();
      return AppDatabase(executor);
    }
  }
  
  /// Expose the generated DAO from AppDatabase so injectable can locate it.
  CartDao cartDao(AppDatabase db) => db.cartDao;
}