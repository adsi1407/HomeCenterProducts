import 'package:mocktail/mocktail.dart';
import 'package:domain/domain.dart';

/// Mock and helpers for CartItemUseCase used in presentation tests.
class MockCartItemUseCase extends Mock implements CartItemUseCase {}

MockCartItemUseCase makeCartItemMockWithItems(List<CartItem> items) {
  final mock = MockCartItemUseCase();
  when(() => mock.getAll()).thenAnswer((_) async => items);
  return mock;
}

MockCartItemUseCase makeCartItemMockThrowOnRemove(Object error) {
  final mock = MockCartItemUseCase();
  when(() => mock.getAll()).thenAnswer((_) async => <CartItem>[]);
  when(() => mock.removeItem(any())).thenThrow(error);
  return mock;
}
