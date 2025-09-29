import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/event/search_event.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/event/search_text_changed.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/event/search_load_more.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_error.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_initial.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_loaded.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_loading.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchProductsBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProductsUseCase _searchProductsUseCase;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  List<Product> _accumulatedResults = [];
  String _lastQuery = '';

  SearchProductsBloc(this._searchProductsUseCase) : super(SearchInitial()) {
    on<SearchTextChanged>((event, emit) async {
      // New query: reset pagination state
      _currentPage = 1;
      _accumulatedResults = [];
      _lastQuery = event.query;
      emit(SearchLoading());
      try {
        final results = await _searchProductsUseCase.call(event.query, _currentPage);
        _accumulatedResults = List.of(results);
        emit(SearchLoaded(_accumulatedResults, currentPage: _currentPage, isLoadingMore: false));
      } catch (e) {
        emit(SearchError('Error al buscar items'));
      }
    });

    on<SearchLoadMore>((event, emit) async {
      final currentState = state;
      if (currentState is SearchLoaded && !_isLoadingMore) {
        // avoid concurrent load-more
        _isLoadingMore = true;
        final nextPage = currentState.currentPage + 1;
        // emit loadingMore state so UI can show footer
        emit(SearchLoaded(List.of(_accumulatedResults), currentPage: currentState.currentPage, isLoadingMore: true));
        try {
          final more = await _searchProductsUseCase.call(_lastQuery, nextPage);
          if (more.isNotEmpty) {
            _accumulatedResults.addAll(more);
          }
          _currentPage = nextPage;
          _isLoadingMore = false;
          emit(SearchLoaded(List.of(_accumulatedResults), currentPage: _currentPage, isLoadingMore: false));
        } catch (e) {
          _isLoadingMore = false;
          emit(SearchError('Error al cargar más items'));
        }
      }
    });
  }
}
