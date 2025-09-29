import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:home_center_products/src/presentation/cart_item/page/cart_page.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/state/cart_loaded.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/cart_bloc.dart';
import 'package:domain/domain.dart';

import '../../common/test_doubles/mock_cart_bloc.dart';

void main() {
  group('CartPage widget', () {
    late MockCartBloc mockCartBloc;

    setUp(() {
      mockCartBloc = MockCartBloc();
    });

    testWidgets('shows items and handles delete confirmation', (tester) async {
      final product = Product(id: 'p1', name: 'Mi Producto');
      final item = CartItem(id: 1, product: product, quantity: 1, addedAt: DateTime.now());

      whenListen(mockCartBloc, Stream.fromIterable([CartLoaded([item])]), initialState: CartLoaded([item]));

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<CartBloc>.value(
          value: mockCartBloc,
          child: const CartPage(),
        ),
      ));

      await tester.pumpAndSettle();

      // Item is visible
      expect(find.text('Mi Producto'), findsOneWidget);

      // Tap delete icon
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Confirm dialog appears
      expect(find.text('Confirmar eliminación'), findsOneWidget);

      // Confirm deletion
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      // SnackBar shown with deleted text
      expect(find.textContaining('eliminado'), findsOneWidget);
    });
  });
}
