import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_center_products/src/presentation/product_search/widgets/product_list_item.dart';
import 'package:domain/domain.dart';

void main() {
  testWidgets('ProductListItem golden', (tester) async {
    final product = Product(id: 'p_g', name: 'Golden Drill', price: 49.9);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: Center(child: SizedBox(width: 300, child: ProductListItem(product: product)))),
    ));

    await tester.pumpAndSettle();

    await expectLater(find.byType(ProductListItem), matchesGoldenFile('goldens/product_list_item_golden.png'));
  });
}
