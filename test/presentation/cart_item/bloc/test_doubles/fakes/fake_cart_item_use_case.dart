import 'package:domain/domain.dart';

class FakeCartItemUseCase implements CartItemUseCase {
  final List<CartItem> Function() _getAll;
  final Future<void> Function(CartItem) _addItem;
  final Future<void> Function(int?) _removeItem;

  FakeCartItemUseCase({
    List<CartItem> Function()? getAll,
    Future<void> Function(CartItem)? addItem,
    Future<void> Function(int?)? removeItem,
  })  : _getAll = getAll ?? (() => <CartItem>[]),
        _addItem = addItem ?? ((_) async {}),
        _removeItem = removeItem ?? ((_) async {});

  @override
  Future<List<CartItem>> getAll() async => _getAll();

  @override
  Future<void> addItem(CartItem item) => _addItem(item);

  @override
  Future<void> removeItem(int? id) => _removeItem(id);
}
