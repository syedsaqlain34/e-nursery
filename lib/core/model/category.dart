import 'product.dart';

class Category {
  final String id;
  final String name;
  final List<Product> products;

  Category({
    required this.id,
    required this.name,
    this.products = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': DateTime.now(),
    };
  }
}
