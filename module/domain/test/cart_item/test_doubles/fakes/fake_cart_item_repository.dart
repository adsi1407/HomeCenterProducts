import 'package:domain/src/cart_item/entity/cart_item.dart';
import 'package:domain/src/cart_item/repository/cart_item_repository.dart';

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
