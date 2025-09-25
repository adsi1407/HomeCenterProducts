class ProductDto {
  final String id;
  final String name;
  final String? imageUrl;
  final double? price;
  final Map<String, dynamic>? raw;

  ProductDto({
    required this.id,
    required this.name,
    this.imageUrl,
    this.price,
    this.raw,
  });

}
