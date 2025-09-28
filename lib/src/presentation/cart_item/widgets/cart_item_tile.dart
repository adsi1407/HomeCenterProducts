import 'package:flutter/material.dart';
import 'package:domain/domain.dart';
import 'package:home_center_products/src/presentation/common/styles.dart';

/// CartItemTile
/// Renders a [CartItem] row with remove and undo callbacks.
class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback? onRemove;
  final VoidCallback? onUndo;

  const CartItemTile({super.key, required this.item, this.onRemove, this.onUndo});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: AppStyles.cardShape,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppStyles.mediumSpacing, vertical: AppStyles.smallSpacing),
        leading: (item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty)
            ? Semantics(
                label: item.product.name,
                child: Image.network(
                  item.product.imageUrl!,
                  width: AppStyles.cartImageSize,
                  fit: BoxFit.cover,
                ),
              )
            : Semantics(
                label: 'No image available for ${item.product.name}',
                child: Container(
                  width: AppStyles.cartImageSize,
                  height: AppStyles.cartImageSize,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: AppStyles.defaultIconSize, color: Colors.grey),
                ),
              ),
        title: Text(item.product.name, style: AppStyles.productTitle(context)),
        subtitle: Text('Cantidad: ${item.quantity}', style: AppStyles.productSubtitle(context)),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
