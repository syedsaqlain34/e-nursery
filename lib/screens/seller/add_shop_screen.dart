import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../map/map_screen.dart';

class SellerAddShopScreen extends StatefulWidget {
  const SellerAddShopScreen({super.key});

  @override
  State<SellerAddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<SellerAddShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _selectedImages = <XFile>[];
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  LatLng? _selectedLocation;

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      _showError('Failed to pick images');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _selectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AlternativeMapScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLocation = result['position'] as LatLng;
        _addressController.text = result['address'] as String;
      });
    }
  }

  Future<String> _uploadImage(XFile image) async {
    try {
      final file = File(image.path);
      if (!await file.exists()) {
        throw Exception('Image file not found');
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      final storageRef =
          FirebaseStorage.instance.ref().child('shops').child(fileName);

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path},
      );

      final uploadTask = storageRef.putFile(file, metadata);
      await uploadTask;

      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> _saveShop() async {
    try {
      setState(() => _isLoading = true);

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      _showLoadingDialog('Uploading images...');
      final List<String> imageUrls = [];
      for (var image in _selectedImages) {
        final url = await _uploadImage(image);
        imageUrls.add(url);
      }

      _updateLoadingDialog('Saving shop details...');
      final shopData = {
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'description': _descriptionController.text.trim(),
        'images': imageUrls,
        'userId': userId,
        'location': {
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
        },
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('shops').add(shopData);

      if (mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        Navigator.pop(context); // Return to previous screen
        _showSuccess('Shop added successfully!');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  void _updateLoadingDialog(String message) {
    if (mounted) {
      Navigator.of(context).pop();
      _showLoadingDialog(message);
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add Shop',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          if (!_isLoading)
            IconButton(
              onPressed: _validateAndSave,
              icon: const Icon(Icons.check_rounded),
              tooltip: 'Save Shop',
              color: Colors.white,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Images Section
                    _buildImagePicker(),

                    // Form Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: 'Shop Name',
                            hint: 'Enter your shop name',
                            icon: Icons.store_rounded,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _descriptionController,
                            label: 'Description',
                            hint: 'Describe your shop...',
                            icon: Icons.description_rounded,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          _buildLocationPicker(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _selectedImages.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildEmptyImageState(),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildImageList(),
            ),
    );
  }

  Widget _buildEmptyImageState() {
    return InkWell(
      onTap: _pickImages,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined,
              size: 48, color: Colors.green[300]),
          const SizedBox(height: 12),
          Text(
            'Add Shop Photos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap to select images',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      itemCount: _selectedImages.length + 1,
      itemBuilder: (context, index) {
        if (index == _selectedImages.length) {
          return _buildAddMoreImagesButton();
        }
        return _buildImageTile(index);
      },
    );
  }

  Widget _buildImageTile(int index) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(_selectedImages[index].path),
              width: 160,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _removeImage(index),
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 16, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreImagesButton() {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: InkWell(
        onTap: _pickImages,
        borderRadius: BorderRadius.circular(8),
        child: Icon(Icons.add, color: Colors.green[700]),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green[300]!),
        ),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? '$label is required' : null,
    );
  }

  Widget _buildLocationPicker() {
    return InkWell(
      onTap: _selectLocation,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_on_rounded, color: Colors.green[700]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedLocation == null
                        ? 'Select Location'
                        : 'Location Selected',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_addressController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _addressController.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _validateAndSave() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedImages.isEmpty) {
        _showError('Please add at least one image');
        return;
      }
      if (_selectedLocation == null) {
        _showError('Please select a location');
        return;
      }
      _saveShop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AddShopScreen extends StatefulWidget {
//   const AddShopScreen({super.key});

//   @override
//   State<AddShopScreen> createState() => _AddShopScreenState();
// }

// class _AddShopScreenState extends State<AddShopScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final ImagePicker _picker = ImagePicker();
//   final List<XFile> _selectedImages = [];
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final List<CategoryWithProducts> _categories = [];
//   bool _isLoading = false;

//   Future<void> _pickImages() async {
//     try {
//       final List<XFile> images = await _picker.pickMultiImage();
//       if (images.isNotEmpty) {
//         setState(() {
//           _selectedImages.addAll(images);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to pick images')),
//       );
//     }
//   }

//   void _removeImage(int index) {
//     setState(() {
//       _selectedImages.removeAt(index);
//     });
//   }

//   void _addCategory() {
//     final nameController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Category'),
//         content: TextFormField(
//           controller: nameController,
//           decoration: InputDecoration(
//             labelText: 'Category Name',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (nameController.text.isNotEmpty) {
//                 setState(() {
//                   _categories.add(
//                     CategoryWithProducts(
//                       id: DateTime.now().toString(),
//                       name: nameController.text,
//                       products: [],
//                     ),
//                   );
//                 });
//                 Navigator.pop(context);
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//             ),
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _addProductToCategory(CategoryWithProducts category) {
//     final nameController = TextEditingController();
//     final priceController = TextEditingController();
//     final descriptionController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Add Product to ${category.name}'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: 'Product Name'),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: priceController,
//                 decoration: const InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: descriptionController,
//                 decoration: const InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (nameController.text.isNotEmpty &&
//                   priceController.text.isNotEmpty) {
//                 setState(() {
//                   final categoryIndex = _categories.indexOf(category);
//                   final products = List<Product>.from(category.products);
//                   products.add(
//                     Product(
//                       id: DateTime.now().toString(),
//                       name: nameController.text,
//                       price: double.tryParse(priceController.text) ?? 0.0,
//                       description: descriptionController.text,
//                     ),
//                   );
//                   _categories[categoryIndex] = CategoryWithProducts(
//                     id: category.id,
//                     name: category.name,
//                     products: products,
//                   );
//                 });
//                 Navigator.pop(context);
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//             ),
//             child: const Text('Add Product'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _saveShop() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedImages.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please add at least one shop image')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final userId = FirebaseAuth.instance.currentUser!.uid;

//       // Upload shop images to Firebase Storage
//       final List<String> shopImageUrls = [];
//       for (var image in _selectedImages) {
//         final ref = FirebaseStorage.instance
//             .ref()
//             .child('shops')
//             .child('${DateTime.now().millisecondsSinceEpoch}_${image.name}');

//         await ref.putFile(File(image.path));
//         final url = await ref.getDownloadURL();
//         shopImageUrls.add(url);
//       }

//       // Create shop document
//       final shopRef = await FirebaseFirestore.instance.collection('shops').add({
//         'name': _nameController.text,
//         'address': _addressController.text,
//         'description': _descriptionController.text,
//         'images': shopImageUrls,
//         'userId': userId,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       // Add categories and products
//       for (var category in _categories) {
//         final categoryRef = await shopRef.collection('categories').add({
//           'name': category.name,
//           'createdAt': FieldValue.serverTimestamp(),
//         });

//         // Add products for this category
//         for (var product in category.products) {
//           await categoryRef.collection('products').add({
//             'name': product.name,
//             'price': product.price,
//             'description': product.description,
//             'createdAt': FieldValue.serverTimestamp(),
//           });
//         }
//       }

//       if (mounted) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Shop added successfully')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to save shop')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Shop'),
//         backgroundColor: Colors.green,
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Shop Images Section
//               Text(
//                 'Shop Images',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               const SizedBox(height: 8),
//               if (_selectedImages.isNotEmpty)
//                 Container(
//                   height: 120,
//                   margin: const EdgeInsets.only(bottom: 16),
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _selectedImages.length,
//                     itemBuilder: (context, index) {
//                       return Stack(
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.only(right: 8),
//                             width: 120,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     File(_selectedImages[index].path)),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 4,
//                             right: 12,
//                             child: GestureDetector(
//                               onTap: () => _removeImage(index),
//                               child: Container(
//                                 padding: const EdgeInsets.all(4),
//                                 decoration: const BoxDecoration(
//                                   color: Colors.red,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.close,
//                                   size: 16,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ElevatedButton.icon(
//                 onPressed: _pickImages,
//                 icon: const Icon(Icons.add_photo_alternate),
//                 label: Text(
//                   _selectedImages.isEmpty
//                       ? 'Add Shop Images'
//                       : 'Add More Images',
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Shop Details Form
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Shop Name',
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Shop name is required' : null,
//               ),
//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: _addressController,
//                 decoration: InputDecoration(
//                   labelText: 'Shop Address',
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Address is required' : null,
//               ),
//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: _descriptionController,
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   labelText: 'Shop Description',
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Description is required' : null,
//               ),
//               const SizedBox(height: 24),

//               // Categories Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Categories',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: _addCategory,
//                     icon: const Icon(Icons.add),
//                     label: const Text('Add Category'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: _categories.length,
//                 itemBuilder: (context, index) {
//                   final category = _categories[index];
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     child: ExpansionTile(
//                       title: Text(category.name),
//                       children: [
//                         ...category.products.map((product) => ListTile(
//                               title: Text(product.name),
//                               subtitle:
//                                   Text('\$${product.price.toStringAsFixed(2)}'),
//                               trailing: Text(product.description),
//                             )),
//                         ListTile(
//                           leading: const Icon(Icons.add),
//                           title: const Text('Add Product'),
//                           onTap: () => _addProductToCategory(category),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 24),

//               // Save Button
//               SizedBox(
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _saveShop,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(color: Colors.white),
//                         )
//                       : const Text(
//                           'Save Shop',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _addressController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
// }

// // Models
// class CategoryWithProducts {
//   final String id;
//   final String name;
//   final List<Product> products;

//   CategoryWithProducts({
//     required this.id,
//     required this.name,
//     required this.products,
//   });
// }

// class Product {
//   final String id;
//   final String name;
//   final double price;
//   final String description;

//   Product({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.description,
//   });
// }
