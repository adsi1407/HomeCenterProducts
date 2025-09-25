import 'package:home_center_products/src/presentation/bloc/event/search_event.dart';

class SearchTextChanged extends SearchEvent {
  final String query;
  SearchTextChanged(this.query);
}