import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_state.dart';

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
