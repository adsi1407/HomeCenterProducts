import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:home_center_products/src/presentation/product_search/page/search_products_page.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/search_products_bloc.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_loaded.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_initial.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_state.dart';
import 'package:domain/domain.dart';
import 'package:home_center_products/l10n/app_localizations.dart';

class MockSearchProductsBloc extends Mock implements SearchProductsBloc {}

void main() {
  testWidgets('shows loading footer when state.isLoadingMore is true', (tester) async {
    final bloc = MockSearchProductsBloc();

  // Create a broadcast controller for the stream of states so multiple listeners may subscribe
  final controller = StreamController<SearchState>.broadcast();
    when(() => bloc.stream).thenAnswer((_) => controller.stream);
    when(() => bloc.state).thenReturn(SearchInitial());

    // Build widget
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<SearchProductsBloc>.value(
        value: bloc,
        child: const SearchProductsPage(),
      ),
    ));

    // Emit a loaded state with some results
    final products = [Product(id: '1', name: 'p1'), Product(id: '2', name: 'p2')];
  controller.add(SearchLoaded(products, currentPage: 1, isLoadingMore: false));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));

    // Expect to find two ProductListItem widgets (they use Product fields internally)
    expect(find.byType(ListView), findsOneWidget);

    // Now emit a loading-more state
  controller.add(SearchLoaded(products, currentPage: 1, isLoadingMore: true));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));

    // Should show CircularProgressIndicator as footer
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await controller.close();
  });
}
