import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../core/model/user_model.dart';
import '../screens/login/login_screen.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _loading = false;

  UserModel? get currentUser => _currentUser;
  bool get loading => _loading;

  Future<void> loadCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          _currentUser = UserModel.fromFirestore(doc);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading user: $e');
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? profileImage,
  }) async {
    if (_currentUser == null) return;

    _loading = true;
    notifyListeners();

    try {
      String? imageUrl;

      // If profileImage is provided as a file path, upload it
      if (profileImage != null) {
        final file = File(profileImage);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profiles')
            .child(
                '${_currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Upload the file with metadata
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'userId': _currentUser!.uid},
        );
        await storageRef.putFile(file, metadata);

        // Get the download URL
        imageUrl = await storageRef.getDownloadURL();
      }

      // Prepare updates
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (imageUrl != null) updates['profileImage'] = imageUrl;

      // Update Firestore only if we have changes
      if (updates.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .update(updates);

        // Create new UserModel with updated values
        _currentUser = UserModel(
          uid: _currentUser!.uid,
          email: _currentUser!.email,
          role: _currentUser!.role,
          name: name ?? _currentUser!.name,
          phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
          profileImage: imageUrl ?? _currentUser!.profileImage,
        );
      }

      _loading = false;
      notifyListeners();
    } catch (e) {
      print('Error updating profile: $e');
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Helper method to delete old profile image if exists
  Future<void> _deleteOldProfileImage() async {
    if (_currentUser?.profileImage != null) {
      try {
        final ref =
            FirebaseStorage.instance.refFromURL(_currentUser!.profileImage!);
        await ref.delete();
      } catch (e) {
        print('Error deleting old profile image: $e');
        // Continue even if deletion fails
      }
    }
  }

  // Method to handle user logout
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // This removes all routes from the stack
        );
      }
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Error logging out: $e');
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }
}
