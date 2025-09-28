import 'package:injectable/injectable.dart';
import 'package:domain/src/suggestion/repository/suggestion_repository.dart';

@injectable
class GetSuggestionsUseCase {
  final SuggestionRepository _repo;

  GetSuggestionsUseCase(this._repo);

  Future<List<String>> call() => _repo.fetchAll();
}
