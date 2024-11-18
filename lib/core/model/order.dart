import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String address;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final double latitude;
  final double longitude;

  OrderModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.latitude,
    required this.longitude,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    // Handle the case where orderDate might be null
    DateTime parseDate(dynamic value) {
      if (value == null) {
        return DateTime.now(); // Default to current time if null
      }
      if (value is Timestamp) {
        return value.toDate();
      }
      return DateTime.now(); // Default for unexpected types
    }

    return OrderModel(
      id: documentId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item))
              .toList() ??
          [],
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      orderDate: parseDate(map['orderDate']), // Using the safe parse method
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': Timestamp.fromDate(orderDate),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class OrderItem {
  final String serviceId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;
  final String shopId;
  final String shopName;

  OrderItem({
    required this.serviceId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.shopId,
    required this.shopName,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      serviceId: map['serviceId'] ?? '',
      title: map['title'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      imageUrl: map['imageUrl'] ?? '',
      shopId: map['shopId'] ?? '',
      shopName: map['shopName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'shopId': shopId,
      'shopName': shopName,
    };
  }

  double get total => price * quantity;
}
