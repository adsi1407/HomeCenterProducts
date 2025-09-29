import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/search_products_bloc.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/event/search_text_changed.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/event/search_load_more.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_loaded.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_loading.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_error.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_initial.dart';
import 'package:domain/domain.dart';

import 'test_doubles/mocks/mock_search_products_use_case.dart';

void main() {
  group('SearchProductsBloc', () {
    test('initial state is SearchInitial', () {
      // Arrange
      final mock = makeSearchProductsMockWithResults([]);
      final bloc = SearchProductsBloc(mock);

      // Assert
      expect(bloc.state, isA<SearchInitial>());
    });

    test('SearchTextChanged success -> emits Loading then Loaded', () async {
      // Arrange
      final mock = makeSearchProductsMockWithResults([Product(id: '1', name: 'p')]);
      final bloc = SearchProductsBloc(mock);

      // Act
      bloc.add(SearchTextChanged('q'));

      // Assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SearchLoading>(),
          isA<SearchLoaded>(),
        ]),
      );
    });

    test('SearchTextChanged failure -> emits Loading then Error', () async {
      // Arrange
      final mock = makeSearchProductsMockThrow(Exception('fail'));
      final bloc = SearchProductsBloc(mock);

      // Act
      bloc.add(SearchTextChanged('x'));

      // Assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SearchLoading>(),
          isA<SearchError>(),
        ]),
      );
    });

    test('SearchLoadMore appends results and increments page', () async {
      // Arrange
      final mock = MockSearchProductsUseCase();
      when(() => mock.call('q', 1)).thenAnswer((_) async => [Product(id: '1', name: 'p1')]);
      when(() => mock.call('q', 2)).thenAnswer((_) async => [Product(id: '2', name: 'p2')]);
      final bloc = SearchProductsBloc(mock);

      // Act
      bloc.add(SearchTextChanged('q'));
      await Future<void>.delayed(Duration.zero);
      bloc.add(SearchLoadMore());

      // Assert: wait for states to be emitted and then inspect
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final s = bloc.state;
      expect(s, isA<SearchLoaded>());
      final loaded = s as SearchLoaded;
      expect(loaded.results.length, 2);
      expect(loaded.currentPage, 2);
    });
  });
}
