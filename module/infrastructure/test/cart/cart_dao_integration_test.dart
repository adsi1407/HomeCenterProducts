import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/cart/app_database.dart';
import 'package:drift/drift.dart' as d;
import 'package:infrastructure/src/cart/cart_dao.dart';
import 'test_doubles/fakes/fake_app_database_factory.dart';

void main() {
  group('CartDao integration (in-memory)', () {
    late AppDatabase db;
    late CartDao dao;

    setUp(() {
      db = FakeAppDatabaseFactory.createInMemory();
      dao = CartDao(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('insertCartItem | valid item | item persisted and retrievable', () async {
      // Arrange
      final item = CartItemCompanion.insert(
        productId: 'p-1',
        name: 'Product 1',
        imageUrl: d.Value(''),
        price: d.Value(12.5),
        quantity: d.Value(2),
        addedAt: d.Value(DateTime.now()),
      );

      // Act
      final id = await dao.insertCartItem(item);

      // Assert
      final all = await dao.getAllItems();
      expect(all, isNotEmpty);
      expect(all.first.id, id);
      expect(all.first.productId, 'p-1');
      expect(all.first.quantity, 2);
    });

    test('deleteByProductId | existing productId | removed and count decreased', () async {
      // Arrange
  await dao.insertCartItem(CartItemCompanion.insert(productId: 'p-a', name: 'A', imageUrl: d.Value(''), price: d.Value(1.0), quantity: d.Value(1), addedAt: d.Value(DateTime.now())));
  await dao.insertCartItem(CartItemCompanion.insert(productId: 'p-b', name: 'B', imageUrl: d.Value(''), price: d.Value(2.0), quantity: d.Value(1), addedAt: d.Value(DateTime.now())));

      // Act
      final removed = await dao.deleteByProductId('p-a');

      // Assert
      expect(removed, 1);
      final all = await dao.getAllItems();
      expect(all.length, 1);
      expect(all.first.productId, 'p-b');
    });

    test('clearCart | multiple items | empties table', () async {
      // Arrange
  await dao.insertCartItem(CartItemCompanion.insert(productId: 'x1', name: 'X1', imageUrl: d.Value(''), price: d.Value(1.0), quantity: d.Value(1), addedAt: d.Value(DateTime.now())));
  await dao.insertCartItem(CartItemCompanion.insert(productId: 'x2', name: 'X2', imageUrl: d.Value(''), price: d.Value(1.0), quantity: d.Value(1), addedAt: d.Value(DateTime.now())));

      // Act
      final removed = await dao.clearCart();

      // Assert
      expect(removed, 2);
      final all = await dao.getAllItems();
      expect(all, isEmpty);
    });

    test('findByProductId | not found | returns null', () async {
      // Arrange
      // no insert

      // Act
      final res = await dao.findByProductId('missing');

      // Assert
      expect(res, isNull);
    });

    test('insertCartItem | duplicate productId | inserts separate rows (no merge)', () async {
      // Arrange
  await dao.insertCartItem(CartItemCompanion.insert(productId: 'dup', name: 'D1', imageUrl: d.Value(''), price: d.Value(1.0), quantity: d.Value(1), addedAt: d.Value(DateTime.now())));

      // Act
  await dao.insertCartItem(CartItemCompanion.insert(productId: 'dup', name: 'D2', imageUrl: d.Value(''), price: d.Value(1.0), quantity: d.Value(3), addedAt: d.Value(DateTime.now())));

      // Assert
      final all = await dao.getAllItems();
      // Current infra behavior: duplicates are separate rows
      expect(all.where((e) => e.productId == 'dup').length, 2);
    });
  });
}
