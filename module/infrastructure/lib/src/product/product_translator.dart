import 'package:domain/domain.dart';
import 'package:infrastructure/src/product/product_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProductTranslator {
  ProductTranslator();

  /// Convierte el JSON tal como viene de la API en un ProductDto.
  /// Aquí centralizamos reglas "sucias" y parsing frágil.
  ProductDto fromApiJsonToDto(Map<String, dynamic> json) {
    // ID
    final id = (json['sku'] ?? json['id'] ?? '').toString();

    // Nombre / displayName
    final name = (json['displayName'] ?? json['name'] ?? '').toString();

    // Imagen: mediaUrls puede ser List<String> o List<Map>
    String? imageUrl;
    final media = json['mediaUrls'];
    if (media is List && media.isNotEmpty) {
      final first = media.first;
      if (first is String) {
        imageUrl = first;
      } else if (first is Map) {
        imageUrl = (first['url'] ?? first['src'] ?? first['value'])?.toString();
      }
    } else {
      // intenta campos alternativos
      imageUrl = (json['image'] ?? json['thumbnail'])?.toString();
    }

    // Precio: buscar tipo NORMAL dentro de prices (lista)
    double? price;
    final prices = json['prices'];
    if (prices is List) {
      try {
        final maps = prices.cast<Map<String, dynamic>>();
        final normal = maps.firstWhere((p) => (p['type'] ?? '').toString().toUpperCase() == 'NORMAL',
            orElse: () => <String, dynamic>{});
        if (normal.isNotEmpty) {
          final candidate = normal['amount'] ?? normal['value'] ?? normal['price'];
          if (candidate != null) {
            price = double.tryParse(candidate.toString());
          }
        }
      } catch (_) {
        // swallow parse issues — mantenemos price = null si falla
      }
    }

    return ProductDto(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      raw: json,
    );
  }

  Product dtoToDomain(ProductDto dto) {
    return Product(
      id: dto.id,
      name: dto.name,
      imageUrl: dto.imageUrl,
      price: dto.price,
      raw: dto.raw,
    );
  }
  
}