import 'package:flutter_test/flutter_test.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/cart_bloc.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_load.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_add.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_remove.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_loading.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_loaded.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_error.dart';
import 'package:domain/domain.dart';
import 'test_doubles/fakes/fake_cart_item_use_case.dart';

void main() {
  group('CartBloc', () {
    test('load | success | emits [Loading, Loaded] with items', () async {
      // Arrange
      final fake = FakeCartItemUseCase(getAll: () => [
        CartItem(
          id: 1,
          product: Product(id: 'p1', name: 'Item 1'),
          quantity: 1,
          addedAt: DateTime(2020, 1, 1),
        ),
      ]);
      final bloc = CartBloc(fake);

      // Act
      bloc.add(CartLoad());

      // Assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CartLoading>(),
          isA<CartLoaded>(),
        ]),
      );
    });

    test('add | success | emits [Loading, Loaded] after add', () async {
      final items = <CartItem>[];
      final fake = FakeCartItemUseCase(
        getAll: () => items,
        addItem: (item) async => items.add(item),
      );

      final bloc = CartBloc(fake);

      bloc.add(CartAdd(CartItem(
        id: null,
        product: Product(id: 'p2', name: 'New'),
        quantity: 1,
        addedAt: DateTime(2020, 1, 2),
      )));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CartLoading>(),
          isA<CartLoaded>(),
        ]),
      );
    });

    test('remove | failure | emits [Loading, Error] when remove throws', () async {
      final fake = FakeCartItemUseCase(
        getAll: () => [],
        removeItem: (id) async => throw Exception('fail'),
      );
      final bloc = CartBloc(fake);

      bloc.add(CartRemove(123));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CartLoading>(),
          isA<CartError>(),
        ]),
      );
    });
  });
}
