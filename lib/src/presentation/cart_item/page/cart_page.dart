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
import 'package:home_center_products/src/presentation/cart_item/widgets/cart_item_tile.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    // trigger load after first frame to avoid side effects during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(CartLoad());
    });
  }

  @override
  Widget build(BuildContext context) {
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
                return CartItemTile(
                  item: item,
                  onRemove: () async {
                    // Confirm before deleting
                    final messenger = ScaffoldMessenger.of(context);

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

                    if (!mounted) return;
                    if (confirmed != true) return;

                    if (item.id != null) {
                      // Remove and show undo
                      context.read<CartBloc>().add(CartRemove(item.id!));
                      messenger.showSnackBar(
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
                      messenger.showSnackBar(
                        const SnackBar(content: Text('El item aún no está guardado en la base de datos')),
                      );
                    }
                  },
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
