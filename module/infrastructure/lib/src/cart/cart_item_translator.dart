import 'package:domain/domain.dart';
import 'package:infrastructure/src/cart/app_database.dart' as drift_table;
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

/// Responsable de convertir entre las entidades generadas por Drift y el dominio.
@lazySingleton
class CartItemTranslator {
  const CartItemTranslator();

  CartItem fromData(drift_table.CartItemData d) {
    final product = Product(
      id: d.productId,
      name: d.name,
      imageUrl: d.imageUrl.isEmpty ? null : d.imageUrl,
      price: d.price,
      raw: null,
    );

    return CartItem(
      id: d.id,
      product: product,
      quantity: d.quantity,
      addedAt: d.addedAt,
    );
  }

  drift_table.CartItemCompanion toCompanion(CartItem item) {
    return drift_table.CartItemCompanion.insert(
      productId: item.product.id,
      name: item.product.name,
      imageUrl: Value(item.product.imageUrl ?? ''),
      price: Value(item.product.price ?? 0.0),
      quantity: Value(item.quantity),
      addedAt: Value(item.addedAt),
    );
  }
}
