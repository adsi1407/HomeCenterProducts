import 'package:domain/domain.dart';
import 'package:home_center_products/src/presentation/bloc/state/search_state.dart';

class SearchLoaded extends SearchState {
  final List<Product> results;
  SearchLoaded(this.results);
}