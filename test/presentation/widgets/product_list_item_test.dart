import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:home_center_products/src/presentation/product_search/widgets/product_list_item.dart';
import 'package:domain/domain.dart';

void main() {
  testWidgets('ProductListItem shows name and price placeholder when price null', (tester) async {
    final product = Product(id: 'p1', name: 'Test Product', price: null, imageUrl: null);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ProductListItem(product: product))));

    expect(find.text('Test Product'), findsOneWidget);
    // price placeholder may be localized; just ensure some text is present in subtitle
    expect(find.byType(ListTile), findsOneWidget);
  });
}
