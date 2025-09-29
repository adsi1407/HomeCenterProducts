import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_center_products/src/presentation/cart_item/widgets/cart_item_tile.dart';
import 'package:domain/domain.dart';

void main() {
  testWidgets('CartItemTile golden', (tester) async {
    final product = Product(id: 'g1', name: 'Golden Product', price: 9.99);
    final item = CartItem(product: product, quantity: 1, addedAt: DateTime.now());

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: Center(child: SizedBox(width: 400, child: CartItemTile(item: item)))),
    ));

    await tester.pumpAndSettle();

    await expectLater(find.byType(CartItemTile), matchesGoldenFile('goldens/cart_item_tile_golden.png'));
  });
}
