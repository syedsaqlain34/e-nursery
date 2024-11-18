// user_type_model.dart
import 'package:flutter/foundation.dart';

class UserTypeModel with ChangeNotifier {
  int _selectedIndex = 0; // 0 for Buyer, 1 for Seller

  int get selectedIndex => _selectedIndex;

  void selectUserType(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
