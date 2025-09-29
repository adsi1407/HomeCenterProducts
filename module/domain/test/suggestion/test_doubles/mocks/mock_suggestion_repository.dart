import 'package:mocktail/mocktail.dart';
import 'package:domain/src/suggestion/repository/suggestion_repository.dart';

class MockSuggestionRepository extends Mock implements SuggestionRepository {}

MockSuggestionRepository makeSuggestionRepoMockWithList(List<String> list) {
  final mock = MockSuggestionRepository();
  when(() => mock.fetchAll()).thenAnswer((_) async => list);
  return mock;
}

MockSuggestionRepository makeSuggestionRepoMockThrow(Object error) {
  final mock = MockSuggestionRepository();
  when(() => mock.fetchAll()).thenThrow(error);
  return mock;
}
