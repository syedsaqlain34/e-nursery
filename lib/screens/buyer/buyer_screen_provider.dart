import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/login_screen.dart';

class HomeProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> logout(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signOut();

      _isLoading = false;
      notifyListeners();

      // Navigate to login screen and clear the navigation stack
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // This removes all routes from the stack
        );
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to logout. Please try again.';
      notifyListeners();
    }
  }
}
