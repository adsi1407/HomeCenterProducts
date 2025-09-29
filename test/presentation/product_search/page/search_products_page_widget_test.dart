import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:home_center_products/src/presentation/product_search/page/search_products_page.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/search_products_bloc.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_loaded.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_state.dart';
import 'package:domain/domain.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/cart_bloc.dart';

import '../../common/test_doubles/mock_cart_bloc.dart';
import 'test_doubles/mocks/mock_search_products_bloc.dart';

void main() {
  group('SearchProductsPage widget', () {
    testWidgets('shows list of ProductListItem when SearchLoaded', (tester) async {
      // Arrange
      final mockSearchBloc = MockSearchProductsBloc();
      final mockCartBloc = MockCartBloc();

      final products = [
        Product(id: 'a', name: 'A', price: 1.0),
        Product(id: 'b', name: 'B', price: 2.0),
      ];

      whenListen<SearchState>(
        mockSearchBloc,
        Stream.fromIterable([SearchLoaded(products)]),
        initialState: SearchLoaded(products),
      );

      // Act
      await tester.pumpWidget(MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SearchProductsBloc>.value(value: mockSearchBloc),
            BlocProvider<CartBloc>.value(value: mockCartBloc),
          ],
          child: const SearchProductsPage(),
        ),
      ));

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart), findsNWidgets(2));
    });
  });
}
