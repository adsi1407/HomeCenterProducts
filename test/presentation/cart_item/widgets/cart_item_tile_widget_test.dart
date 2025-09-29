import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_center_products/src/presentation/cart_item/widgets/cart_item_tile.dart';
import 'package:home_center_products/l10n/app_localizations.dart';
import 'package:domain/domain.dart';

void main() {
  group('CartItemTile widget', () {
    testWidgets('renders product name, quantity and delete button', (tester) async {
      // Arrange
      final product = Product(id: 'p1', name: 'Producto 1', price: 5.0);
      final item = CartItem(product: product, quantity: 2, addedAt: DateTime.now());
      var removed = false;

      // Act
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: CartItemTile(item: item, onRemove: () { removed = true; })),
      ));

      // Assert
      expect(find.text('Producto 1'), findsOneWidget);
  expect(find.text('Quantity: 2'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);

      // Trigger remove
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      expect(removed, isTrue);
    });

    testWidgets('shows placeholder when image is missing', (tester) async {
      // Arrange
      final product = Product(id: 'p2', name: 'Sin imagen', price: 1.0);
      final item = CartItem(product: product, quantity: 1, addedAt: DateTime.now());

      // Act
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: CartItemTile(item: item)),
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });
  });
}
