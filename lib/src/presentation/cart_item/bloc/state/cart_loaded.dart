import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_state.dart';
import 'package:domain/domain.dart';

class CartLoaded extends CartState {
  final List<CartItem> items;
  CartLoaded(this.items);
}
