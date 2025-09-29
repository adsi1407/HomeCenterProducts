import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_center_products/src/presentation/product_search/widgets/product_list_item.dart';
import 'package:domain/domain.dart';

void main() {
  group('ProductListItem widget', () {
    testWidgets('renders product name and formatted price and calls onAdd', (tester) async {
      // Arrange
      final product = Product(id: 'p1', name: 'Test Product', price: 12.5, imageUrl: null);
      var addCalled = false;

      // Act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProductListItem(product: product, onAdd: () => addCalled = true),
        ),
      ));

      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$12.50'), findsOneWidget);

      // Tap add
      await tester.tap(find.byIcon(Icons.add_shopping_cart));
      await tester.pumpAndSettle();
      expect(addCalled, isTrue);
    });
  });
}
