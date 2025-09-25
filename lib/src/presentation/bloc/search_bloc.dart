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
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  //final SearchItemsUseCase _searchUseCase;

  SearchBloc() : super(SearchInitial()) {
    on<SearchTextChanged>((event, emit) async {
      emit(SearchLoading());
      try {
        final results = [""];//await _searchUseCase.call(event.query);
        emit(SearchLoaded(results));
      } catch (e) {
        emit(SearchError('Error al buscar items'));
      }
    });
  }
}