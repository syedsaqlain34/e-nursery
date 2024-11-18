import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:plant_project/core/services/payment_serivce.dart';
import 'package:plant_project/screens/buyer/buyer_screen_provider.dart';
import 'package:plant_project/screens/buyer_and_seller/navigatoin_seller_screen.dart';
import 'package:plant_project/screens/card/card_provider.dart';
import 'package:plant_project/screens/navigation/navigation_screen.dart';
import 'package:plant_project/screens/login/login_provider.dart';
import 'package:plant_project/screens/select_buyer_seller/select_buyer_seller_provider.dart';
import 'package:plant_project/screens/sign_up/sign_up_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';
import 'provider/user_provider.dart';
import 'screens/buyer/shop_provider.dart';
import 'screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51NwgHwDLhc7CAq0WXEhFjBFRnbsBNALfgojMa31mxcdEHansVRhCyPahuKikFwpRUVZXqCHOah8htZDE0FEScKFk00sL95eOnG';
  await StripeService.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => UserTypeModel()),
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ShopFilterProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: TextTheme(
                bodyLarge: TextStyle(
                  fontSize: 16.sp,
                ),
                bodyMedium: TextStyle(fontSize: 14.sp),
              ),
            ),
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;
        if (user == null) {
          return const SplashScreen();
        }

        // User is logged in, now check their role
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              // Handle case where user exists in Auth but not in Firestore
              return const SplashScreen();
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final userRole = userData['role'] as String;

            // Navigate based on user role
            switch (userRole) {
              case 'buyer':
                return const NavigationScreen();
              case 'seller':
                return const NavigationSellerScreen();
              default:
                return const SplashScreen();
            }
          },
        );
      },
    );
  }
}
