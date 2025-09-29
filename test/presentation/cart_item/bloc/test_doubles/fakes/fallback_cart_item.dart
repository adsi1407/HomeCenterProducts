import 'package:mocktail/mocktail.dart';
import 'fake_cart_item.dart';

void registerPresentationCartItemDoubles() {
  registerFallbackValue(CartItemFake());
}
