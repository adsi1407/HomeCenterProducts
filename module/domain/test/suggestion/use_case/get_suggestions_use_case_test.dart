import 'package:flutter_test/flutter_test.dart';
import 'package:domain/src/suggestion/use_case/get_suggestions_use_case.dart';
import '../../test_doubles/fakes/fakes.dart';

void main() {
  group('GetSuggestionsUseCase', () {
    test('call | default repository | returns five suggestions', () async {
      // Arrange
  final repo = FakeSuggestionRepository();
      final useCase = GetSuggestionsUseCase(repo);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.length, 5);
      expect(result, contains('Taladros'));
    });

    test('call | repository throws | bubble exception', () async {
      // Arrange
  final repo = FakeSuggestionRepository(() async => throw Exception('error'));
      final useCase = GetSuggestionsUseCase(repo);

      // Act & Assert
      expect(() async => await useCase.call(), throwsA(isA<Exception>()));
    });

    test('call | empty list | returns empty list', () async {
      // Arrange
  final repo = FakeSuggestionRepository(() async => <String>[]);
      final useCase = GetSuggestionsUseCase(repo);

      // Act
      final res = await useCase.call();

      // Assert
      expect(res, isEmpty);
    });

    test('call | default repository | returns list in expected order', () async {
      final repo = FakeSuggestionRepository();
      final useCase = GetSuggestionsUseCase(repo);

      final res = await useCase.call();
      expect(res, [
        'Taladros',
        'Humedad',
        'Cascos',
        'botas de seguridad',
        'tornillos'
      ]);
    });
  });
}
