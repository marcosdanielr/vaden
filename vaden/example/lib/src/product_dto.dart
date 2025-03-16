import 'package:vaden/vaden.dart';

@DTO()
class ProductDto {
  final String name;
  final double price;

  ProductDto({required this.name, required this.price});
}
