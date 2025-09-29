import 'package:mocktail/mocktail.dart';
import 'package:domain/domain.dart';

/// Mock and helpers for SearchProductsUseCase used in presentation tests.
class MockSearchProductsUseCase extends Mock implements SearchProductsUseCase {}

MockSearchProductsUseCase makeSearchProductsMockWithResults(List<Product> results) {
  final mock = MockSearchProductsUseCase();
  when(() => mock.call(any(), any())).thenAnswer((_) async => results);
  return mock;
}

MockSearchProductsUseCase makeSearchProductsMockThrow(Object error) {
  final mock = MockSearchProductsUseCase();
  when(() => mock.call(any(), any())).thenThrow(error);
  return mock;
}
