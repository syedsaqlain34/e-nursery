import 'category.dart';

class Shop {
  final String id;
  final String name;
  final String address;
  final String description;
  final List<String> images;
  final String userId;
  final List<Category> categories;

  Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.userId,
    this.images = const [],
    this.categories = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'description': description,
      'images': images,
      'userId': userId,
      'createdAt': DateTime.now(),
    };
  }
}
