import 'package:flutter_test/flutter_test.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/search_products_bloc.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/event/search_text_changed.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_loading.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_loaded.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_error.dart';
import 'package:domain/domain.dart';
import 'test_doubles/fakes/fake_search_products_use_case.dart';

void main() {
  group('SearchProductsBloc', () {
    test('onSearch | success | emits [Loading, Loaded] with results', () async {
      // Arrange
  final fakeUseCase = FakeSearchProductsUseCase((q, p) => [
    const Product(id: '1', name: 'taladro', price: 10.0),
      ]);
      final bloc = SearchProductsBloc(fakeUseCase);

      // Act
      bloc.add(SearchTextChanged('taladro'));

      // Assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SearchLoading>(),
          isA<SearchLoaded>(),
        ]),
      );
    });

    test('onSearch | failure | emits [Loading, Error] when useCase throws', () async {
      // Arrange
      final fakeUseCase = FakeSearchProductsUseCase((q, p) => throw Exception('fail'));
      final bloc = SearchProductsBloc(fakeUseCase);

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
  });
}
