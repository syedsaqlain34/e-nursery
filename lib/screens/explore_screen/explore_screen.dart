// // Import necessary packages
// import 'package:flutter/material.dart';
// import 'package:plant_project/screens/card/cart.dart';

// class ExploreScreen extends StatelessWidget {
//   const ExploreScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text(
//           'Search',
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Search Container
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: const TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Search...',
//                     border: InputBorder.none,
//                     prefixIcon: Icon(Icons.search, color: Colors.grey),
//                     contentPadding: EdgeInsets.symmetric(vertical: 15),
//                   ),
//                 ),
//               ),
//               // Trending Searches
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Image.asset(
//                     'assets/Group 88 (1).png',
//                     width: 30,
//                   ),
//                   const SizedBox(width: 8),
//                   const Text('Trending Searches',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: [
//                   _buildSearchTag('Plant'),
//                   _buildSearchTag('Seeds'),
//                   _buildSearchTag('Ferns'),
//                   _buildSearchTag('Pots'),
//                   _buildSearchTag('Planters'),
//                   _buildSearchTag('Square'),
//                   _buildSearchTag('Planters By'),
//                   _buildSearchTag('Wall Mount'),
//                   _buildSearchTag('Gifts'),
//                   _buildSearchTag('Green Gifts'),
//                   _buildSearchTag('Soil & Fruit'),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // Explore Products Section
//               Text(
//                 'Explore Products',
//                 style: TextStyle(
//                     color: Colors.grey[700],
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               Image.asset('assets/Rectangle 73.png'),
//               const SizedBox(height: 15),
//               // Product Header with Sort Button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Winter Plants',
//                     style: TextStyle(
//                         color: Colors.grey[700],
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Padding(
//                       padding: EdgeInsets.all(4.0),
//                       child: Text(
//                         'Sort',
//                         style: TextStyle(fontSize: 10, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               // Product Items in Grid
//               GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.7,
//                   mainAxisSpacing: 16,
//                   crossAxisSpacing: 16,
//                 ),
//                 itemCount: 8,
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.only(top: 10),
//                 itemBuilder: (context, index) {
//                   return _buildProductItem(
//                     context,
//                     imagePath: 'assets/Rectangle 62.png',
//                     title: 'Product ${index + 1}',
//                     price: '${(index + 1) * 100} PKR',
//                     oldPrice: '${(index + 1) * 200} PKR',
//                     discount: '-${(index + 1) * 50}%',
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget for Search Tags
//   Widget _buildSearchTag(String text) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       padding: const EdgeInsets.all(8.0),
//       child: Text(text),
//     );
//   }

//   // Widget for Product Items
//   Widget _buildProductItem(
//     BuildContext context, {
//     required String imagePath,
//     required String title,
//     required String price,
//     required String oldPrice,
//     required String discount,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image.asset(
//           imagePath,
//           width: 130,
//         ),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 5),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               price,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 12,
//               ),
//             ),
//             const SizedBox(width: 4),
//             Text(
//               oldPrice,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 12,
//                 color: Colors.grey,
//                 decoration: TextDecoration.lineThrough,
//               ),
//             ),
//             const SizedBox(width: 4),
//             Text(
//               discount,
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: Color(0xFF8BC667),
//               ),
//             ),
//           ],
//         ),
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.star, size: 10, color: Colors.amber),
//             Icon(Icons.star, size: 10, color: Colors.amber),
//             Icon(Icons.star, size: 10, color: Colors.amber),
//             Icon(Icons.star_outline, size: 10, color: Colors.amber),
//             Icon(Icons.star_outline, size: 10, color: Colors.amber),
//           ],
//         ),
//         const SizedBox(height: 10),
//         // Buy Button
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//           onPressed: () {
//             _showBuyDialog(context, title, price);
//           },
//           child: const Text(
//             'Buy',
//             style: TextStyle(fontSize: 12, color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   }

//   // Function to show Buy Dialog with improved design
//   void _showBuyDialog(BuildContext context, String title, String price) {
//     String selectedColor = 'Green'; // Default value
//     String selectedBrand = 'Brand 1'; // Default value

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           backgroundColor: Colors.white,
//           title: const Text(
//             'Confirm Purchase',
//             style: TextStyle(color: Colors.green),
//           ),
//           content: StatefulBuilder(
//             builder: (context, setState) {
//               return SizedBox(
//                 width: 300,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text('You are about to buy:'),
//                     const SizedBox(height: 10),
//                     Text(title,
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 10),
//                     Text('Price: $price',
//                         style: const TextStyle(color: Colors.grey)),
//                     const SizedBox(height: 20),
//                     const Text('Select Color:',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     DropdownButton<String>(
//                       value: selectedColor,
//                       items: <String>['Green', 'Red', 'Blue', 'Yellow']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedColor = newValue!;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     const Text('Select Brand:',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     DropdownButton<String>(
//                       value: selectedBrand,
//                       items: <String>['Brand 1', 'Brand 2', 'Brand 3']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedBrand = newValue!;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Navigate to CartScreen when confirmed
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const CartScreen(),
//                   ),
//                 );
//               },
//               child: const Text(
//                 'Confirm',
//                 style: TextStyle(
//                   color: Colors.green,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
