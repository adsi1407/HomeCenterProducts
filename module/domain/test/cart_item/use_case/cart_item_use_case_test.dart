import 'package:flutter_test/flutter_test.dart';
import 'package:domain/src/cart_item/use_case/cart_item_use_case.dart';
import 'package:domain/src/cart_item/entity/cart_item.dart';
import 'package:domain/src/product/entity/product.dart';
import 'test_doubles/mocks/mock_cart_item_repository.dart';
import 'test_doubles/fakes/fallback_cart_item.dart' as td;

void main() {
  setUpAll(() => td.registerCartItemTestDoubles());

  group('CartItemUseCase', () {
    test('addItem | valid item | item added', () async {
      // Arrange
      final repo = makeCartRepoWithItems([]);
      final useCase = CartItemUseCase(repo);
      final item = CartItem(id: 1, product: const Product(id: '101', name: 'P', price: 1.0, imageUrl: null), quantity: 2, addedAt: DateTime.now());

      // Act
      await useCase.addItem(item);

      // Assert
      final all = await useCase.getAll();
      expect(all, isNotEmpty);
      expect(all.first.id, 1);
    });

    test('addItem | non-positive quantity | throws ArgumentError', () async {
  // Arrange
  final repo = makeCartRepoWithItems([]);
  final useCase = CartItemUseCase(repo);
  final item = CartItem(id: 2, product: const Product(id: '102', name: 'P2', price: 2.0, imageUrl: null), quantity: 0, addedAt: DateTime.now());

  // Act & Assert
  expect(() async => await useCase.addItem(item), throwsA(isA<ArgumentError>()));
    });

    test('removeItem | valid id | item removed', () async {
      // Arrange
      final item = CartItem(id: 3, product: const Product(id: '103', name: 'P3', price: 3.0, imageUrl: null), quantity: 1, addedAt: DateTime.now());
      final repo = makeCartRepoWithItems([item]);
      final useCase = CartItemUseCase(repo);

      // Act
      await useCase.removeItem(3);

      // Assert
      final all = await useCase.getAll();
      expect(all, isEmpty);
    });

    test('removeItem | null id | throws ArgumentError', () async {
  // Arrange
  final repo = MockCartItemRepository();
  final useCase = CartItemUseCase(repo);

  // Act & Assert
  expect(() async => await useCase.removeItem(null), throwsA(isA<ArgumentError>()));
    });

    test('getAll | repository throws | bubble exception', () async {
  // Arrange
  final repo = makeCartRepoThrowOnFetch();
  final useCase = CartItemUseCase(repo);

  // Act & Assert
  expect(() async => await useCase.getAll(), throwsA(isA<Exception>()));
    });
  });
}
