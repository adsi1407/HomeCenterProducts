import 'package:domain/src/cart_item/entity/cart_item.dart';
import 'package:domain/src/cart_item/repository/cart_item_repository.dart';
import 'package:domain/src/product/entity/product.dart';
import 'package:domain/src/product/repository/product_repository.dart';
import 'package:domain/src/suggestion/repository/suggestion_repository.dart';

/// Test doubles used across domain tests.
/// These are simple in-memory fakes intended to exercise use-cases without
/// bringing in external dependencies. They follow the Test Double theory:
/// - Fake: has a working implementation but is simpler than production.
/// - Stub: can be configured to return fixed values.
/// - Spy behavior can be read via the `calls` lists exposed here.

class FakeProductRepository implements ProductRepository {
  final Future<List<Product>> Function({required String query, int page}) _handler;
  FakeProductRepository(this._handler);

  @override
  Future<List<Product>> searchProducts({required String query, int page = 1}) {
    return _handler(query: query, page: page);
  }
}

class FakeCartItemRepository implements CartItemRepository {
  final List<CartItem> store = [];
  final Future<List<CartItem>> Function()? fetchHandler;
  final Future<void> Function(CartItem item)? addHandler;
  final Future<void> Function(int? id)? removeHandler;

  FakeCartItemRepository({this.fetchHandler, this.addHandler, this.removeHandler});

  @override
  Future<void> add(CartItem item) async {
    if (addHandler != null) return addHandler!(item);
    store.add(item);
  }

  @override
  Future<List<CartItem>> fetchAll() async {
    if (fetchHandler != null) return fetchHandler!();
    return store;
  }

  @override
  Future<void> remove(int? id) async {
    if (removeHandler != null) return removeHandler!(id);
    store.removeWhere((e) => e.id == id);
  }
}

class FakeSuggestionRepository implements SuggestionRepository {
  final Future<List<String>> Function()? handler;
  FakeSuggestionRepository([this.handler]);

  @override
  Future<List<String>> fetchAll() async {
    if (handler != null) return handler!();
    return ['Taladros', 'Humedad', 'Cascos', 'botas de seguridad', 'tornillos'];
  }
}
