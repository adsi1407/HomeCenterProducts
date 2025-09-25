import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final double? price;
  final Map<String, dynamic>? raw;

  const Product({
    required this.id,
    required this.name,
    this.imageUrl,
    this.price,
    this.raw,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, price];
}