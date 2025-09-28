import 'dart:async';
import 'dart:convert';
import 'dart:io';

class FakeHttpServer {
  final HttpServer _server;
  final Map<String, int> _hitCount = {};
  final Map<String, _RouteHandler> _routes = {};

  FakeHttpServer._(this._server) {
    _server.listen(_handleRequest, onError: (e) {});
  }

  static Future<FakeHttpServer> bind() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    return FakeHttpServer._(server);
  }

  int get port => _server.port;

  Uri uri(String path) => Uri.parse('http://localhost:${port}${path}');

  void on(String path, int statusCode, Map<String, dynamic> jsonBody, {Map<String, String>? headers}) {
    _routes[path] = _RouteHandler(statusCode, jsonBody, headers ?? {});
  }

  int hits(String path) => _hitCount[path] ?? 0;

  Future<void> shutdown() async {
    await _server.close(force: true);
  }

  void _handleRequest(HttpRequest req) async {
    final routeKeyExact = req.uri.path;
    _hitCount[routeKeyExact] = (_hitCount[routeKeyExact] ?? 0) + 1;

    final handler = _routes[routeKeyExact];
    if (handler == null) {
      req.response.statusCode = HttpStatus.notFound;
      req.response.close();
      return;
    }

    handler.headers.forEach((k, v) => req.response.headers.set(k, v));
    req.response.statusCode = handler.statusCode;
    req.response.headers.contentType = ContentType.json;
    req.response.write(jsonEncode(handler.jsonBody));
    await req.response.close();
  }
}

class _RouteHandler {
  final int statusCode;
  final Map<String, dynamic> jsonBody;
  final Map<String, String> headers;
  _RouteHandler(this.statusCode, this.jsonBody, this.headers);
}
