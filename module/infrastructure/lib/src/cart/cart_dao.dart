import 'package:drift/drift.dart';
import 'package:infrastructure/src/cart/app_database.dart';
import 'package:infrastructure/src/cart/cart_item.dart';

part 'cart_dao.g.dart';

@DriftAccessor(tables: [CartItem])
class CartDao extends DatabaseAccessor<AppDatabase> with _$CartDaoMixin {
  final AppDatabase db;
  CartDao(this.db) : super(db);

  // Insert usando Insertable<CartItemData> (acepta CartItemCompanion también)
  Future<int> insertCartItem(Insertable<CartItemData> item) => into(cartItem).insert(item);

  // Obtener todos
  Future<List<CartItemData>> getAllItems() => select(cartItem).get();

  // Borrar por productId
  Future<int> deleteByProductId(String productId) =>
      (delete(cartItem)..where((t) => t.productId.equals(productId))).go();

  // Borrar por id (primary key)
  Future<int> deleteById(int id) =>
      (delete(cartItem)..where((t) => t.id.equals(id))).go();

  // Limpiar
  Future<int> clearCart() => delete(cartItem).go();

  // Buscar por productId
  Future<CartItemData?> findByProductId(String productId) =>
      (select(cartItem)..where((t) => t.productId.equals(productId))).getSingleOrNull();
}