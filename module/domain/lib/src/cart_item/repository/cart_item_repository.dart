import 'package:domain/src/cart_item/entity/cart_item.dart';

/// Repositorio abstracto para CartItem en el dominio.
/// Solo la interfaz — sin implementaciones de infraestructura aquí.
abstract class CartItemRepository {
  /// Obtiene todos los items del carrito
  Future<List<CartItem>> fetchAll();

  /// Agrega un item al carrito
  Future<void> add(CartItem item);

  /// Elimina un item por id
  Future<void> remove(int? id);
}
