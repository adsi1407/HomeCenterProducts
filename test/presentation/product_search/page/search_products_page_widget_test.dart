import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// kept minimal imports; bloc_test not required here
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:home_center_products/src/presentation/product_search/page/search_products_page.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/search_products_bloc.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_loaded.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_state.dart';
import 'package:domain/domain.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/cart_bloc.dart';
import 'package:home_center_products/l10n/app_localizations.dart';

import '../../common/test_doubles/mock_cart_bloc.dart';
import 'test_doubles/mocks/mock_search_products_bloc.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

void main() {
  group('SearchProductsPage widget', () {
    testWidgets('shows list of ProductListItem when SearchLoaded and shows loading footer on load more', (tester) async {
      // Arrange
      final mockSearchBloc = MockSearchProductsBloc();
      final mockCartBloc = MockCartBloc();

      final products = [
        Product(id: 'a', name: 'A', price: 1.0),
        Product(id: 'b', name: 'B', price: 2.0),
      ];

  // Provide initial and subsequent states via a broadcast controller so multiple listeners can subscribe
  final controller = StreamController<SearchState>.broadcast();
      when(() => mockSearchBloc.stream).thenAnswer((_) => controller.stream);
      when(() => mockSearchBloc.state).thenReturn(SearchLoaded(products, currentPage: 1, isLoadingMore: false));

      // Act
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SearchProductsBloc>.value(value: mockSearchBloc),
            BlocProvider<CartBloc>.value(value: mockCartBloc),
          ],
          child: const SearchProductsPage(),
        ),
      ));

  // Let initial state render
  controller.add(SearchLoaded(products, currentPage: 1, isLoadingMore: false));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));

      // Assert initial render contains product items
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart), findsNWidgets(2));

  // Act: emit loading-more state
  controller.add(SearchLoaded(products, currentPage: 1, isLoadingMore: true));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));

      // Assert footer loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      await controller.close();
    });
  });
}
