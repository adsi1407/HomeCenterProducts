import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_event.dart';
import 'package:domain/domain.dart';

class CartAdd extends CartEvent {
  final CartItem item;
  CartAdd(this.item);
}
