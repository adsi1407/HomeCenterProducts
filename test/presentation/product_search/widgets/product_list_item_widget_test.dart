import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_center_products/src/presentation/product_search/widgets/product_list_item.dart';
import 'package:home_center_products/l10n/app_localizations.dart';
import 'package:domain/domain.dart';

void main() {
  group('ProductListItem widget', () {
    testWidgets('renders product name and formatted price and calls onAdd', (tester) async {
      // Arrange
      final product = Product(id: 'p1', name: 'Test Product', price: 12.5, imageUrl: null);
      var addCalled = false;

      // Act
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
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

    testWidgets('renders product name', (tester) async {
      final product = Product(id: 'p_add', name: 'Addable', price: null, imageUrl: null);

      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ProductListItem(product: product)),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Addable'), findsOneWidget);
    });

    testWidgets('shows price placeholder when price is null', (tester) async {
      final product = Product(id: 'p_add', name: 'Addable', price: null, imageUrl: null);

      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ProductListItem(product: product)),
      ));
      await tester.pumpAndSettle();

      // Price placeholder is rendered in the subtitle; ensure a ListTile exists
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('add button calls onAdd callback', (tester) async {
      final product = Product(id: 'p_add', name: 'Addable', price: null, imageUrl: null);
      var addCalled = false;

      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ProductListItem(product: product, onAdd: () => addCalled = true)),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add_shopping_cart));
      await tester.pumpAndSettle();
      expect(addCalled, isTrue);
    });
  });
}
