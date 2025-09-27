import 'package:home_center_products/src/presentation/product_search/bloc/state/search_state.dart';
import 'package:domain/domain.dart';

class SearchLoaded extends SearchState {
  final List<Product> results;
  SearchLoaded(this.results);
}
