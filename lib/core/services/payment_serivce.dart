// lib/services/stripe_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripeService {
  static const String _secretKey =
      'sk_test_51NwgHwDLhc7CAq0Wxa7ju6viBcxAu9Sk8KfEmtGxiqytd3DTa9pR2l2v9sKnAxvXPHb43XgZ663En0lNjxRoLDee00cXrQPOYg';
  static const String _publishableKey =
      'pk_test_51NwgHwDLhc7CAq0WXEhFjBFRnbsBNALfgojMa31mxcdEHansVRhCyPahuKikFwpRUVZXqCHOah8htZDE0FEScKFk00sL95eOnG';
  static Future<void> initialize() async {
    try {
      Stripe.publishableKey = _publishableKey;
      await Stripe.instance.applySettings();
    } catch (e) {
      print('Stripe initialization error: $e');
      // Handle the error appropriately
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amount,
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<PaymentStatus> processPayment(double amount) async {
    try {
      // Create payment intent
      final paymentIntent = await createPaymentIntent(
        (amount * 100).toInt().toString(), // Convert to cents
        'USD',
      );

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Your Plant Shop Name',
          style: ThemeMode.light,
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      return PaymentStatus(
        success: true,
        message: 'Payment completed successfully',
      );
    } catch (e) {
      return PaymentStatus(
        success: false,
        message: e.toString(),
      );
    }
  }
}

class PaymentStatus {
  final bool success;
  final String message;
  final String? orderId; // Added for order tracking
  final double? amount;
  final String? clientSecret; // Added for Stripe handling
  final String? paymentId; // Added for payment tracking

  PaymentStatus({
    required this.success,
    required this.message,
    this.orderId,
    this.amount,
    this.clientSecret,
    this.paymentId,
  });
}
