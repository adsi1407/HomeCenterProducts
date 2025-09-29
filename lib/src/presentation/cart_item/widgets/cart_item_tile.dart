import 'package:flutter/material.dart';
import 'package:domain/domain.dart';
import 'package:home_center_products/src/presentation/common/styles.dart';
import 'package:home_center_products/l10n/app_localizations.dart' as gen_l10n;
import 'package:cached_network_image/cached_network_image.dart';

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
                child: CachedNetworkImage(
                  imageUrl: item.product.imageUrl!,
                  width: AppStyles.cartImageSize,
                  height: AppStyles.cartImageSize,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: AppStyles.cartImageSize,
                    height: AppStyles.cartImageSize,
                    color: Colors.grey[200],
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: AppStyles.cartImageSize,
                    height: AppStyles.cartImageSize,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: AppStyles.defaultIconSize, color: Colors.grey),
                  ),
                ),
              )
                : Semantics(
                label: item.product.name,
                child: Container(
                  width: AppStyles.cartImageSize,
                  height: AppStyles.cartImageSize,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: AppStyles.defaultIconSize, color: Colors.grey),
                ),
              ),
        title: Text(item.product.name, style: AppStyles.productTitle(context)),
  subtitle: Text(gen_l10n.AppLocalizations.of(context)?.cartQuantity(item.quantity) ?? 'Cantidad: ${item.quantity}', style: AppStyles.productSubtitle(context)),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
