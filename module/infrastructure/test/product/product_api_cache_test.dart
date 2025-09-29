import 'package:flutter_test/flutter_test.dart';
import 'test_doubles/fakes/fake_http_server.dart';
import 'test_doubles/fakes/fake_dio_factory.dart';
import 'test_doubles/fakes/fake_product_api.dart';

void main() {
  group('ProductApi integration (HTTP + cache)', () {
  test('searchRaw | cache-first | second request served from cache (no network hit)', () async {
      // Arrange: start server and route
  final server = await FakeHttpServer.bind();

      // ProductApi.searchRaw uses path '/s/search/v1/soco/' in production.
      const path = '/s/search/v1/soco/';
      final responseJson = {
        'data': {
          'results': [
            {'id': '1', 'name': 'X'},
            {'id': '2', 'name': 'Y'},
          ]
        }
      };

      server.on(path, 200, responseJson);

  final dio = FakeDioFactory.create(baseUrl: 'http://localhost:${server.port}');
  final testApi = FakeProductApi(dio);
  // Use cache-first policy for tests to ensure cache is used on second request
  // Note: create a Dio instance with CacheOptions set to cacheFirst

  // Act: first request
  final first = await testApi.searchRaw('query', 1);

      // Assert: server was hit once
      expect(server.hits(path), 1);
      expect(first.length, 2);

      // Act: second request (should be cached)
  final second = await testApi.searchRaw('query', 1);

      // Assert: server not hit again (served from cache)
      expect(server.hits(path), 1);
      expect(second.length, 2);

      await server.shutdown();
    });
  });
}
