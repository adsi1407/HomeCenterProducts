import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_center_products/src/presentation/cart_item/widgets/cart_item_tile.dart';
import 'package:domain/domain.dart';

void main() {
  testWidgets('CartItemTile provides semantics label when image missing', (tester) async {
    final product = Product(id: 's1', name: 'Sin imagen', price: 1.0);
    final item = CartItem(product: product, quantity: 1, addedAt: DateTime.now());

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: CartItemTile(item: item))));
    await tester.pumpAndSettle();

  // The widget wraps the placeholder with a Semantics(label: 'No image available for <name>')
  final iconFinder = find.byIcon(Icons.image_not_supported);
  expect(iconFinder, findsOneWidget, reason: 'Expected placeholder icon to be present');

  // Instead of relying on a single Semantics ancestor (there can be many),
  // collect all semantics nodes and assert one of them contains the expected label.
  // Find a Semantics widget whose label contains the expected text.
  final semanticsWidgetFinder = find.byWidgetPredicate((widget) {
    if (widget is Semantics) {
      final label = widget.properties.label;
      return label != null && label.contains('No image available for Sin imagen');
    }
    return false;
  }, description: 'Semantics widget with label containing missing image text');

  expect(semanticsWidgetFinder, findsOneWidget, reason: 'Expected a Semantics widget with the missing image label');
  });
}
