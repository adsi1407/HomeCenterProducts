import 'package:home_center_products/src/presentation/bloc/state/search_state.dart';

class SearchLoaded extends SearchState {
  final List<String> results;
  SearchLoaded(this.results);
}