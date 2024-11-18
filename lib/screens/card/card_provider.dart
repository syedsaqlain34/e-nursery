// lib/providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  final String imageUrl;
  final String shopId;
  final String shopName;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.shopId,
    required this.shopName,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'shopId': shopId,
      'shopName': shopName,
      'quantity': quantity,
    };
  }

  double get total => price * quantity;
}

class CartProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> addItem({
    required String productId,
    required String title,
    required double price,
    required String imageUrl,
    required String shopId,
    required String shopName,
    int quantity = 1,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'User not authenticated';

      if (_items.containsKey(productId)) {
        // Update quantity if item exists
        _items.update(
          productId,
          (existingItem) => CartItem(
            id: existingItem.id,
            productId: existingItem.productId,
            title: existingItem.title,
            price: existingItem.price,
            imageUrl: existingItem.imageUrl,
            shopId: existingItem.shopId,
            shopName: existingItem.shopName,
            quantity: existingItem.quantity + quantity,
          ),
        );
      } else {
        // Add new item
        final docRef = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .add({
          'productId': productId,
          'title': title,
          'price': price,
          'imageUrl': imageUrl,
          'shopId': shopId,
          'shopName': shopName,
          'quantity': quantity,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _items.putIfAbsent(
          productId,
          () => CartItem(
            id: docRef.id,
            productId: productId,
            title: title,
            price: price,
            imageUrl: imageUrl,
            shopId: shopId,
            shopName: shopName,
            quantity: quantity,
          ),
        );
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeItem(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'User not authenticated';

      if (!_items.containsKey(productId)) return;

      final cartItem = _items[productId]!;
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(cartItem.id)
          .delete();

      _items.remove(productId);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      if (quantity < 1) return;

      final user = _auth.currentUser;
      if (user == null) throw 'User not authenticated';

      if (!_items.containsKey(productId)) return;

      final cartItem = _items[productId]!;
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(cartItem.id)
          .update({'quantity': quantity});

      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          title: existingItem.title,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
          shopId: existingItem.shopId,
          shopName: existingItem.shopName,
          quantity: quantity,
        ),
      );

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> loadCart() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'User not authenticated';

      final cartSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      final Map<String, CartItem> loadedItems = {};

      for (var doc in cartSnapshot.docs) {
        final data = doc.data();
        loadedItems[data['productId']] = CartItem(
          id: doc.id,
          productId: data['productId'],
          title: data['title'],
          price: data['price'].toDouble(),
          imageUrl: data['imageUrl'],
          shopId: data['shopId'],
          shopName: data['shopName'],
          quantity: data['quantity'],
        );
      }

      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'User not authenticated';

      final batch = _firestore.batch();
      final cartDocs = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      for (var doc in cartDocs.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      _items.clear();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
