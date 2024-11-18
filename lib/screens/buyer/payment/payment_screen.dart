import 'package:flutter/material.dart';
import 'package:plant_project/screens/buyer/payment/bank_payment_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: const Color(0XFF8BC667),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField(label: 'Cardholder Name'),
              const SizedBox(height: 16),
              _buildTextField(label: 'Card Number', isNumeric: true),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        label: 'Expiry Date (MM/YY)', isNumeric: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(label: 'CVV', isNumeric: true),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Billing Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(label: 'Street Address'),
              const SizedBox(height: 16),
              _buildTextField(label: 'City'),
              const SizedBox(height: 16),
              _buildTextField(label: 'Zip Code', isNumeric: true),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add payment processing logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment successful!')),
                      );
                      Navigator.pop(context); // Go back after payment
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF8BC667),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                    ),
                    child: const Text('Confirm Payment'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BankPaymentScreen()));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0XFF8BC667),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('or'),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, bool isNumeric = false}) {
    return TextField(
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
