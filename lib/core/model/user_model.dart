import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String role; // 'buyer' or 'seller'
  String? name;
  String? profileImage;
  String? phoneNumber;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.name,
    this.profileImage,
    this.phoneNumber,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      role: data['role'] ?? 'buyer',
      name: data['name'],
      profileImage: data['profileImage'],
      phoneNumber: data['phoneNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'name': name,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
    };
  }
}
