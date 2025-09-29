import 'package:flutter/material.dart';
import 'package:domain/domain.dart';
import 'package:home_center_products/src/presentation/common/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// ProductListItem
/// - Inputs: [product], [onAdd]
/// - Renders a Card/ListTile for a [Product].
class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onAdd;

  const ProductListItem({super.key, required this.product, this.onAdd});

  String _formatPrice(double? price) {
    if (price == null) return 'N/A';
    return '\$${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppStyles.smallSpacing / 2),
      shape: AppStyles.cardShape,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppStyles.mediumSpacing, vertical: AppStyles.smallSpacing),
        leading: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
            ? Semantics(
                label: product.name,
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl!,
                  width: AppStyles.productImageSize,
                  height: AppStyles.productImageSize,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: AppStyles.productImageSize,
                    height: AppStyles.productImageSize,
                    color: Colors.grey[200],
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: AppStyles.productImageSize,
                    height: AppStyles.productImageSize,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 28, color: Colors.grey),
                  ),
                ),
              )
            : Semantics(
                label: 'No image available for ${product.name}',
                child: Container(
                  width: AppStyles.productImageSize,
                  height: AppStyles.productImageSize,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 28, color: Colors.grey),
                ),
              ),
        title: Text(product.name, style: AppStyles.productTitle(context)),
        subtitle: Text(_formatPrice(product.price), style: AppStyles.productSubtitle(context)),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: onAdd,
        ),
      ),
    );
  }
}
