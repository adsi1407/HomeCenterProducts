abstract class SuggestionRepository {
  /// Return the list of suggestions (e.g. from infra or a remote source)
  Future<List<String>> fetchAll();
}
