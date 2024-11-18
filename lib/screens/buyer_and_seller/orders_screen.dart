// import 'package:flutter/material.dart';

// class OrdersScreen extends StatelessWidget {
//   const OrdersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'My Orders',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Order List Items
//             _buildOrderItem('Hassan Ayaz'),
//             _buildOrderItem('Syed Saqlain'),
//             _buildOrderItem('Noaman Imtiaz'),
//             _buildOrderItem('Noaman Imtiaz'), _buildOrderItem('Noaman Imtiaz'),
//             _buildOrderItem('Noaman Imtiaz'),

//             const SizedBox(height: 20),
//             const Text(
//               "Gardner's",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper method to build order items
//   Widget _buildOrderItem(String name) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           children: [
//             const Icon(Icons.person, size: 30, color: Colors.green),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 name,
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios_outlined, size: 15),
//           ],
//         ),
//       ),
//     );
//   }
// }
