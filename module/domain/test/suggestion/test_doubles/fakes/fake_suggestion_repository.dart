import 'package:domain/src/suggestion/repository/suggestion_repository.dart';

class FakeSuggestionRepository implements SuggestionRepository {
  final Future<List<String>> Function()? handler;
  FakeSuggestionRepository([this.handler]);

  @override
  Future<List<String>> fetchAll() async {
    if (handler != null) return handler!();
    return ['Taladros', 'Humedad', 'Cascos', 'botas de seguridad', 'tornillos'];
  }
}
