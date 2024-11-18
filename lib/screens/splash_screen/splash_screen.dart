import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:plant_project/screens/select_buyer_seller/select_byer_or_seller_screen.dart';
import 'package:plant_project/screens/login/login_screen.dart';
import 'package:plant_project/screens/sign_up/sign_up_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // Navigate to the next screen after a delay
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const LoginScreen(), //SelectByerOrSellerScreen
          ),
        );
      });
    });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/loading screen.png'),
      ),
    );
  }
}

class loginselection extends StatelessWidget {
  const loginselection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFD3EDBF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/image 7.png'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                },
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                      color: const Color(0XFFA4E894),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Center(child: Text('SignUp')),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                      color: const Color(0XFF24AF01),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Center(child: Text('Login')),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
