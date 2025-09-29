import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:home_center_products/src/presentation/cart_item/widgets/cart_item_tile.dart';
import 'package:home_center_products/l10n/app_localizations.dart';
import 'package:domain/domain.dart';

void main() {
  testWidgets('CartItemTile shows product name and quantity', (tester) async {
    final product = Product(id: 'p2', name: 'Cart Product', price: 5.0, imageUrl: null);
  final cartItem = CartItem(id: 1, product: product, quantity: 2, addedAt: DateTime.now());

    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: CartItemTile(item: cartItem)),
    ));

    expect(find.text('Cart Product'), findsOneWidget);
    expect(find.textContaining('Cantidad'), findsOneWidget);
  });
}
