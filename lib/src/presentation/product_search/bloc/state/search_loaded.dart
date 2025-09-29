import 'package:home_center_products/src/presentation/product_search/bloc/state/search_state.dart';
import 'package:domain/domain.dart';

class SearchLoaded extends SearchState {
  final List<Product> results;
  final int currentPage;
  final bool isLoadingMore;

  SearchLoaded(
    this.results, {
    this.currentPage = 1,
    this.isLoadingMore = false,
  });
}
