import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_center_products/src/presentation/bloc/event/search_event.dart';
import 'package:home_center_products/src/presentation/bloc/event/search_text_changed.dart';
import 'package:home_center_products/src/presentation/bloc/state/search_error.dart';
import 'package:home_center_products/src/presentation/bloc/state/search_initial.dart';
import 'package:home_center_products/src/presentation/bloc/state/search_loaded.dart';
import 'package:home_center_products/src/presentation/bloc/state/search_loading.dart';
import 'package:home_center_products/src/presentation/bloc/state/search_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchProductsBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProductsUseCase _searchProductsUseCase;

  SearchProductsBloc(this._searchProductsUseCase) : super(SearchInitial()) {
    on<SearchTextChanged>((event, emit) async {
      emit(SearchLoading());
      try {
        final results = await _searchProductsUseCase.call(event.query, 1);
        emit(SearchLoaded(results));
      } catch (e) {
        emit(SearchError('Error al buscar items'));
      }
    });
  }
}