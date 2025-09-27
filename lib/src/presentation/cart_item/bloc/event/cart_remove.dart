import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_event.dart';

class CartRemove extends CartEvent {
  final int id;
  CartRemove(this.id);
}
