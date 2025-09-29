import 'package:flutter_test/flutter_test.dart';
import 'package:domain/src/product/entity/product.dart';

void main() {
  group('Product entity', () {
    test('equality and props include expected fields', () {
      // Arrange
      const p1 = Product(id: '1', name: 'Nail', price: 2.5, imageUrl: 'http://img');
      const p2 = Product(id: '1', name: 'Nail', price: 2.5, imageUrl: 'http://img');
      const p3 = Product(id: '2', name: 'Screw');

      // Act & Assert
      expect(p1, equals(p2));
      expect(p1 == p3, isFalse);
      expect(p1.props, containsAll(<Object?>['1', 'Nail', 'http://img', 2.5]));
    });

    test('handles null optional fields and works in Set', () {
      // Arrange
      const a = Product(id: 'a', name: 'A', price: null, imageUrl: null);
      const b = Product(id: 'a', name: 'A', price: null, imageUrl: null);

      // Act
  final set = <Product>{};
  set.addAll([a, b]);

      // Assert
      expect(a.price, isNull);
      expect(a.imageUrl, isNull);
      expect(set.length, 1); // equality/hashCode via Equatable
    });
  });
}
