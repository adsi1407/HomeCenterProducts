import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/product/product_translator.dart';
import 'package:infrastructure/src/product/product_dto.dart';

void main() {
  final translator = ProductTranslator();

  group('ProductTranslator.fromApiJsonToDto', () {
    test('parses sku and displayName and mediaUrls as list of strings', () {
      final json = {
        'sku': 'SKU123',
        'displayName': 'Taladro X',
        'mediaUrls': ['https://img/1.png', 'https://img/2.png'],
        'prices': [
          {'type': 'NORMAL', 'amount': 123.45}
        ]
      };

      final dto = translator.fromApiJsonToDto(json);

      expect(dto.id, 'SKU123');
      expect(dto.name, 'Taladro X');
      expect(dto.imageUrl, 'https://img/1.png');
      expect(dto.price, 123.45);
    });

    test('parses mediaUrls as list of maps and picks url/src/value', () {
      final json = {
        'id': 'ID-1',
        'name': 'Producto',
        'mediaUrls': [
          {'url': 'https://a'},
        ],
        'prices': [
          {'type': 'normal', 'price': '99.9'}
        ]
      };

      final dto = translator.fromApiJsonToDto(json);
      expect(dto.id, 'ID-1');
      expect(dto.name, 'Producto');
      expect(dto.imageUrl, 'https://a');
      expect(dto.price, 99.9);
    });

    test('falls back to image/thumbnail when mediaUrls missing and handles missing price', () {
      final json = {
        'id': 'ID-2',
        'name': 'NoPrice',
        'image': 'https://fallback',
      };

      final dto = translator.fromApiJsonToDto(json);
      expect(dto.imageUrl, 'https://fallback');
      expect(dto.price, isNull);
    });

    test('handles malformed prices gracefully', () {
      final json = {
        'sku': 'X',
        'name': 'BadPrices',
        'prices': 'not-a-list',
      };

      final dto = translator.fromApiJsonToDto(json);
      expect(dto.price, isNull);
    });
  });

  group('ProductTranslator.dtoToDomain', () {
    test('converts dto to domain Product', () {
      final dto = ProductDto(id: '1', name: 'n', imageUrl: null, price: 1.2, raw: {'a': 1});
      final domain = translator.dtoToDomain(dto);
      expect(domain.id, '1');
      expect(domain.name, 'n');
      expect(domain.imageUrl, isNull);
      expect(domain.price, 1.2);
    });
  });
}
