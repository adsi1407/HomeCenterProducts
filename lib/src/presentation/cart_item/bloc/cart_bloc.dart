import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_event.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_load.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_add.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_remove.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_state.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_loading.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_loaded.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_error.dart';
import 'package:domain/domain.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartItemUseCase _useCase;

  CartBloc(this._useCase) : super(CartLoading()) {
    on<CartLoad>(_onLoad);
    on<CartAdd>(_onAdd);
    on<CartRemove>(_onRemove);
  }

  Future<void> _onLoad(CartLoad event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await _useCase.getAll();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError('Error loading cart'));
    }
  }

  Future<void> _onAdd(CartAdd event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await _useCase.addItem(event.item);
      final items = await _useCase.getAll();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError('Error adding item'));
    }
  }

  Future<void> _onRemove(CartRemove event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await _useCase.removeItem(event.id);
      final items = await _useCase.getAll();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError('Error removing item'));
    }
  }
}
