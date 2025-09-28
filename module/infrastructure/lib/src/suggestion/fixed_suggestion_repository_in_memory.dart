import 'package:injectable/injectable.dart';
import 'package:domain/domain.dart';

@LazySingleton(as: SuggestionRepository)
class FixedSuggestionRepositoryInMemory implements SuggestionRepository {
  @override
  Future<List<String>> fetchAll() async {
    // fixed list of suggestions requested by product owner
    return [
      'Taladros',
      'Humedad',
      'Cascos',
      'botas de seguridad',
      'tornillos',
    ];
  }
}
