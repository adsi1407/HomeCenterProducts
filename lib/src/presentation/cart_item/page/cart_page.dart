import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/cart_bloc.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_loading.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_loaded.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_error.dart';
import 'package:home_center_products/l10n/app_localizations.dart' as gen_l10n;
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
        title: Text(gen_l10n.AppLocalizations.of(context)?.cartTitle ?? 'Carrito'),
      ),
      body: BlocBuilder<CartBloc, dynamic>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            final items = state.items;
            if (items.isEmpty) {
              return Center(child: Text(gen_l10n.AppLocalizations.of(context)?.cartEmpty ?? 'El carrito está vacío'));
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
                        title: Text(gen_l10n.AppLocalizations.of(context)?.cartDeleteConfirmTitle ?? 'Confirmar eliminación'),
                        content: Text(gen_l10n.AppLocalizations.of(context)?.cartDeleteConfirmContent(item.product.name) ?? '¿Eliminar "${item.product.name}" del carrito?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(gen_l10n.AppLocalizations.of(context)?.commonCancel ?? 'Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(gen_l10n.AppLocalizations.of(context)?.commonDelete ?? 'Eliminar'),
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
                          content: Text(gen_l10n.AppLocalizations.of(context)?.cartDeletedSnackbar(item.product.name) ?? '"${item.product.name}" eliminado'),
                          action: SnackBarAction(
                            label: 'Deshacer',
                            onPressed: () {
                              // Re-insert the item (best-effort)
                              context.read<CartBloc>().add(CartAdd(item));
                            },
                          ),
                        ),
                      );

                      // Bloc should update state after removal; avoid forcing an extra load
                    } else {
                      // Item not persisted yet: inform the user
                      messenger.showSnackBar(
                        SnackBar(content: Text(gen_l10n.AppLocalizations.of(context)?.cartNotSavedMessage ?? 'El item aún no está guardado en la base de datos')),
                      );
                    }
                  },
                );
              },
            );
          } else if (state is CartError) {
            final localized = gen_l10n.AppLocalizations.of(context)?.cartErrorLoading;
            return Center(child: Text(localized ?? state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
