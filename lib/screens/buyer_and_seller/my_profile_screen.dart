import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_project/screens/buyer_and_seller/user%20profile/edit_profile.dart';
import 'package:provider/provider.dart';
import '../../../provider/user_provider.dart';
import '../login/login_screen.dart';

class my_profile_screen extends StatefulWidget {
  const my_profile_screen({super.key});

  @override
  _my_profile_screenState createState() => _my_profile_screenState();
}

class _my_profile_screenState extends State<my_profile_screen> {
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    // Load user data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadCurrentUser();
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? selectedImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (selectedImage != null) {
        setState(() {
          _imageFile = selectedImage;
        });

        // Show loading indicator
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Updating profile image...')),
          );
        }

        // Update profile image in provider
        await context.read<UserProvider>().updateProfile(
              profileImage: selectedImage.path,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile image updated successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 100, 11),
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.currentUser;

          if (userProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null) {
            return const Center(child: Text('No user data available'));
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: _getProfileImage(user.profileImage),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(6),
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // User Information
                  Text(
                    user.name.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const Divider(height: 40, thickness: 2),

                  // Options
                  _buildOption(
                    'Edit Profile',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            currentName: user.name.toString(),
                            currentEmail: user.email,
                            currentImageUrl: user.profileImage,
                          ),
                        ),
                      );

                      if (result == true) {
                        // Refresh profile data
                        context.read<UserProvider>().loadCurrentUser();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildOption('Membership'),
                  const SizedBox(height: 10),
                  _buildOption('Terms and Conditions'),
                  const SizedBox(height: 10),
                  _buildOption('Privacy Policy'),
                  const SizedBox(height: 10),
                  _buildOption('About Us'),
                  const SizedBox(height: 30),

                  // Logout Section
                  GestureDetector(
                    onTap: () async {
                      log("message");
                      // Handle logout
                      try {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) =>
                                false, // This removes all routes from the stack
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to logout: $e')),
                          );
                        }
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(child: Text('App version 1.0.0')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ImageProvider _getProfileImage(String? profileImage) {
    if (_imageFile != null) {
      return FileImage(File(_imageFile!.path));
    }
    if (profileImage != null && profileImage.isNotEmpty) {
      return NetworkImage(profileImage);
    }
    return const AssetImage('assets/profile_picture.png');
  }

  Widget _buildOption(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 181, 187, 181),
              Color.fromARGB(255, 157, 186, 118)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
