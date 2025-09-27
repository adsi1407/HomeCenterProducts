import 'package:domain/src/cart_item/entity/cart_item.dart';
import 'package:domain/src/cart_item/repository/cart_item_repository.dart';

/// Caso de uso para operaciones de CartItem en el dominio.
class CartItemUseCase {
  final CartItemRepository _repository;

  CartItemUseCase(this._repository);

  /// Obtiene todos los items
  Future<List<CartItem>> getAll() => _repository.fetchAll();

  /// Agrega un item
  Future<void> addItem(CartItem item) async {
    // Aquí se podría añadir validación de dominio
    if (item.quantity <= 0) {
      throw ArgumentError('quantity must be greater than zero');
    }

    await _repository.add(item);
  }

  /// Elimina un item por id
  Future<void> removeItem(int? id) async {
    if (id == null) {
      throw ArgumentError('id must not be null');
    }
    await _repository.remove(id);
  }
}
