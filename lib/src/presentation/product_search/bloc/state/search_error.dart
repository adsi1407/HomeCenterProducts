import 'package:home_center_products/src/presentation/product_search/bloc/state/search_state.dart';

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
