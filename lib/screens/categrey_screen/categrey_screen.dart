import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the grid
    final List<Map<String, String>> items = [
      {'image': 'assets/Rectangle 62.png', 'text': 'Winter Plant'},
      {'image': 'assets/Rectangle 62.png', 'text': 'Summer Plant'},
      {'image': 'assets/Rectangle 62.png', 'text': 'Spring Plant'},
      {'image': 'assets/Rectangle 62.png', 'text': 'Autumn Plant'},
      {'image': 'assets/Rectangle 62.png', 'text': 'All Weather Plant'},
      {'image': 'assets/Rectangle 62.png', 'text': 'Indoor Plant'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/Mask Group (7).png'), // Header image
            Container(
              height: 50,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0XFF8BC667),
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 86, 178, 90), Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: const Center(
                child: Text(
                  'Plants',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          blurRadius: 3),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 100, // Set the height of the image carousel
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildImageCard('assets/pngwing 6.png'),
                    _buildImageCard('assets/pngwing 5.png'),
                    _buildImageCard('assets/pngwing 8.png'),
                    _buildImageCard('assets/pngwing 4.png'),
                    _buildImageCard('assets/pngwing 6.png'), // 5th Image
                    _buildImageCard('assets/pngwing 5.png'), // 6th Image
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Check out our diverse range of plants available for every season! Whether you prefer winter greens or vibrant summer blooms, we have something for everyone.',
                style: TextStyle(fontSize: 16, color: Color(0XFF757272)),
              ),
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 17, color: Color(0XFF757272)),
              ),
            ),

            const SizedBox(height: 10),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8, // Adjusted for better visual appeal
                mainAxisSpacing: 16, // Space between rows
                crossAxisSpacing: 16, // Space between columns
              ),
              itemCount: items.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                return _buildCategoryCard(items[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(String imagePath) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0), // Spacing between images
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: 76, // Set width for the card
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, String> item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              item['image']!,
              fit: BoxFit.cover,
              height: 100, // Fixed height for uniformity
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item['text']!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '200 PKR',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
                Text(
                  '400 PKR',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  '-50%',
                  style: TextStyle(fontSize: 12, color: Color(0XFF8BC667)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
