// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  //make payment intent
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((int.parse(amount)) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var secretKey =
          "sk_test_51NwgHwDLhc7CAq0Wxa7ju6viBcxAu9Sk8KfEmtGxiqytd3DTa9pR2l2v9sKnAxvXPHb43XgZ663En0lNjxRoLDee00cXrQPOYg";
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body: ${response.body.toString()}');
      return jsonDecode(response.body.toString());
    } catch (err) {
      print('Error charging user: ${err.toString()}');
    }
  }
}
