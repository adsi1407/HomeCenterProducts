import 'package:flutter_test/flutter_test.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/cart_bloc.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_load.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_add.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_remove.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_loading.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_loaded.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_error.dart';
import 'package:domain/domain.dart';
import 'package:mocktail/mocktail.dart';
import 'test_doubles/mocks/mock_cart_item_use_case.dart';
import 'test_doubles/fakes/fallback_cart_item.dart' as td;

void main() {
  setUpAll(() => td.registerPresentationCartItemDoubles());
  group('CartBloc', () {
    test('load | success | emits [Loading, Loaded] with items', () async {
      // Arrange
      final mock = makeCartItemMockWithItems([
        CartItem(
          id: 1,
          product: Product(id: 'p1', name: 'Item 1'),
          quantity: 1,
          addedAt: DateTime(2020, 1, 1),
        ),
      ]);
      final bloc = CartBloc(mock);

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
      // Arrange
      final mock = MockCartItemUseCase();
      final items = <CartItem>[];
      when(() => mock.getAll()).thenAnswer((_) async => items);
      when(() => mock.addItem(any())).thenAnswer((inv) async {
        final CartItem item = inv.positionalArguments[0] as CartItem;
        items.add(item);
      });
      final bloc = CartBloc(mock);

      // Act: add a new item
      bloc.add(CartAdd(CartItem(
        id: null,
        product: Product(id: 'p2', name: 'New'),
        quantity: 1,
        addedAt: DateTime(2020, 1, 2),
      )));

      // Assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CartLoading>(),
          isA<CartLoaded>(),
        ]),
      );
    });

    test('remove | failure | emits [Loading, Error] when remove throws', () async {
      // Arrange
      final mock = makeCartItemMockThrowOnRemove(Exception('fail'));
      final bloc = CartBloc(mock);

      // Act
      bloc.add(CartRemove(123));

      // Assert
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
