import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/product/product_cache.dart';

void main() {
  group('ProductCache', () {
    test('set and get returns stored list and respects TTL', () async {
      final cache = ProductCache();
      cache.set<int>('k', [1, 2, 3]);
      final res = cache.get<int>('k');
      expect(res, [1, 2, 3]);

      // expire by setting entry artificially
      cache.set<int>('tmp', [9], timeToLive: Duration(milliseconds: 1));
      await Future.delayed(Duration(milliseconds: 10));
      final got = cache.get<int>('tmp');
      expect(got, isNull);
    });

    test('invalidate and clear work', () {
      final cache = ProductCache();
      cache.set<String>('a', ['x']);
      expect(cache.get<String>('a'), isNotNull);
      cache.invalidate('a');
      expect(cache.get<String>('a'), isNull);

      cache.set<String>('b', ['y']);
      cache.clear();
      expect(cache.get<String>('b'), isNull);
    });
  });
}
