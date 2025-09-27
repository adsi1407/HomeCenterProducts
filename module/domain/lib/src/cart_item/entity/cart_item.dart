import 'package:domain/src/product/entity/product.dart';

class CartItem {
  final int? id; // puede ser null antes de persistir
  final Product product;
  final int quantity;
  final DateTime addedAt;

  const CartItem({
    this.id,
    required this.product,
    this.quantity = 1,
    required this.addedAt,
  });
}