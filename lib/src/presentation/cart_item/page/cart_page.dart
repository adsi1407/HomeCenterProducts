import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/cart_bloc.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_loading.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_loaded.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_error.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_load.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_remove.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_add.dart';
import 'package:domain/domain.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // trigger load when opening
    context.read<CartBloc>().add(CartLoad());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
      ),
      body: BlocBuilder<CartBloc, dynamic>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            final items = state.items;
            if (items.isEmpty) {
              return const Center(child: Text('El carrito está vacío'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final CartItem item = items[index];
                return Card(
                  child: ListTile(
                    leading: (item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty)
                        ? Image.network(
                            item.product.imageUrl!,
                            width: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 56,
                              height: 56,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image, size: 24, color: Colors.grey),
                            ),
                          )
                        : Container(
                            width: 56,
                            height: 56,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
                          ),
                    title: Text(item.product.name),
                    subtitle: Text('Cantidad: ${item.quantity}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // Confirm before deleting
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar eliminación'),
                            content: Text('¿Eliminar "${item.product.name}" del carrito?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed != true) return;

                        if (item.id != null) {
                          // Remove and show undo
                          context.read<CartBloc>().add(CartRemove(item.id!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"${item.product.name}" eliminado'),
                              action: SnackBarAction(
                                label: 'Deshacer',
                                onPressed: () {
                                  // Re-insert the item (best-effort)
                                  context.read<CartBloc>().add(CartAdd(item));
                                },
                              ),
                            ),
                          );

                          // Force reload to refresh list (Bloc will also refresh on remove, but ensure it)
                          context.read<CartBloc>().add(CartLoad());
                        } else {
                          // Item not persisted yet: inform the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('El item aún no está guardado en la base de datos')),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
