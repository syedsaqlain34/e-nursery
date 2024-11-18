import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login/login_screen.dart';
import 'select_buyer_seller_provider.dart';

class SelectByerOrSellerScreen extends StatelessWidget {
  const SelectByerOrSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userTypeModel = Provider.of<UserTypeModel>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 233, 216),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Buyer or Seller',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ToggleButtons(
              borderColor: Colors.green,
              selectedBorderColor: Colors.green,
              fillColor: Colors.green.withOpacity(0.2),
              color: Colors.green,
              selectedColor: Colors.green,
              borderRadius: BorderRadius.circular(20),
              isSelected: [
                userTypeModel.selectedIndex == 0,
                userTypeModel.selectedIndex == 1
              ],
              onPressed: (index) {
                userTypeModel.selectUserType(index);
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Buyer'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Seller'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: userTypeModel.selectedIndex == 0
                  ? const Column(
                      key: ValueKey<int>(0),
                      children: [
                        Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.green,
                        ),
                        Text(
                          'Buyer selected',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                      ],
                    )
                  : const Column(
                      key: ValueKey<int>(1),
                      children: [
                        Icon(
                          Icons.store,
                          size: 50,
                          color: Colors.green,
                        ),
                        Text(
                          'Seller selected',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
