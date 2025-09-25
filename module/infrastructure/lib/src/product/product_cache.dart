import 'dart:collection';
import 'package:infrastructure/src/product/product_cache_entry.dart';
import 'package:injectable/injectable.dart';

/// Cache simple en memoria: clave -> lista de productos
@lazySingleton
class ProductCache {
  final Duration defaultTtl;
  final _map = HashMap<String, CacheEntry<List<dynamic>>>();

  ProductCache({this.defaultTtl = const Duration(minutes: 10)});

  List<T>? get<T>(String key) {
    final entry = _map[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _map.remove(key);
      return null;
    }
    // cast seguro: quien llama debe conocer el tipo
    return (entry.value).cast<T>();
  }

  void set<T>(String key, List<T> value, {Duration? timeToLive}) {
    _map[key] = CacheEntry<List<dynamic>>(value, DateTime.now(), timeToLive ?? defaultTtl);
  }

  void invalidate(String key) => _map.remove(key);

  void clear() => _map.clear();
}
