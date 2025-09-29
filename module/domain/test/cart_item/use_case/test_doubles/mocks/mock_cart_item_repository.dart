import 'package:mocktail/mocktail.dart';
import 'package:domain/src/cart_item/entity/cart_item.dart';
import 'package:domain/src/cart_item/repository/cart_item_repository.dart';

class MockCartItemRepository extends Mock implements CartItemRepository {}

MockCartItemRepository makeCartRepoWithItems(List<CartItem> items) {
  final mock = MockCartItemRepository();
  // Use a mutable store so tests can exercise add/remove and then fetchAll
  final store = <CartItem>[...items];
  when(() => mock.fetchAll()).thenAnswer((_) async => store);
  when(() => mock.add(any())).thenAnswer((inv) async {
    final it = inv.positionalArguments[0] as CartItem;
    store.add(it);
  });
  when(() => mock.remove(any())).thenAnswer((inv) async {
    final id = inv.positionalArguments[0] as int?;
    store.removeWhere((e) => e.id == id);
  });
  return mock;
}

MockCartItemRepository makeCartRepoThrowOnFetch() {
  final mock = MockCartItemRepository();
  when(() => mock.fetchAll()).thenThrow(Exception('db'));
  return mock;
}
