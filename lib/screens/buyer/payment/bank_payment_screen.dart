import 'package:flutter/material.dart';

class BankPaymentScreen extends StatelessWidget {
  const BankPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Payment Method'),
        backgroundColor: const Color(0XFF8BC667),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select your bank:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Add your bank selection UI here, for example:
              Container(
                height: 93,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/Mask Group (9).png',
                      width: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'RBL Bank Credit Card',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '2398 88 **** 1234',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.green),
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 93,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/Mask Group (10).png',
                      width: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'RBL Bank Credit Card',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '2398 88 **** 1234',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.green),
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 93,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/Mask Group (11).png',
                      width: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Google Play',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '2398 88 **** 1234',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.green),
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total Shipping',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text('Free')
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text('5400')
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                  ),
                  Text('5400')
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your payment processing logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment initiated!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF8BC667),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankOption(String bankName) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(bankName),
        trailing: const Icon(Icons.check),
        onTap: () {
          // Handle bank selection
        },
      ),
    );
  }
}
