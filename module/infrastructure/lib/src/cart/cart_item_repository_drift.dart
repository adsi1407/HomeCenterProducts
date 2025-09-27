import 'package:injectable/injectable.dart';
import 'package:domain/domain.dart';
import 'package:infrastructure/src/cart/cart_dao.dart';
// ...existing code...
import 'package:infrastructure/src/cart/cart_item_translator.dart';

/// Implementacion de repositorio de CartItem usando Drift (CartDao).
@LazySingleton(as: CartItemRepository)
class CartItemRepositoryDrift implements CartItemRepository {
  final CartDao _dao;
  final CartItemTranslator _translator;

  CartItemRepositoryDrift(this._dao, this._translator);

  @override
  Future<void> add(CartItem item) async {
    final companion = _translator.toCompanion(item);
    await _dao.insertCartItem(companion);
  }

  @override
  Future<List<CartItem>> fetchAll() async {
    final rows = await _dao.getAllItems();
    return rows.map(_translator.fromData).toList();
  }

  @override
  Future<void> remove(int? id) async {
    if (id == null) return;
    await _dao.deleteById(id);
  }
}
