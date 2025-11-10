import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../chats/widgets/custom_bar.dart';
import 'admin_detail_screen.dart';
import 'admin_storage_service.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final localData = await AdminStorageService.getAdminProfile();
      if (localData != null) {
        setState(() {
          _profileData = localData;
          _isLoading = false;
        });
      }

      _loadFromFirestore();
    } catch (e) {
      final defaultData = {
        'firstName': 'LA Digital',
        'lastName': 'Agency',
        'role': 'Owner',
        'profileImage': null,
      };
      setState(() {
        _profileData = defaultData;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFromFirestore() async {
    try {
      final userId = _auth.currentUser!.uid;
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final freshData = doc.data()!;

        await AdminStorageService.saveAdminProfile(freshData);

        if (mounted) {
          setState(() {
            _profileData = freshData;
          });
        }
      }
    } catch (e) {
      //
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (pickedFile != null) {
        await _updateProfileImage(File(pickedFile.path));
      }
    } catch (e) {
      _showSnackBar('Error picking image');
    }
  }

  Future<void> _updateProfileImage(File imageFile) async {
    try {
      _showSnackBar('Updating profile picture...');

      final bytes = await imageFile.readAsBytes();

      if (bytes.length > 2 * 1024 * 1024) {
        _showSnackBar('Image size too large. Please select a smaller image.');
        return;
      }

      final base64Image = base64Encode(bytes);
      final userId = _auth.currentUser!.uid;

      final updatedData = {...?_profileData, 'profileImage': base64Image};

      await AdminStorageService.saveAdminProfile(updatedData);

      setState(() {
        _profileData = updatedData;
      });

      _showSnackBar('Profile picture updated successfully!');

      _updateFirestoreImage(userId, base64Image);
    } catch (e) {
      _showSnackBar('Error updating profile picture');
    }
  }

  Future<void> _updateFirestoreImage(String userId, String base64Image) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'profileImage': base64Image,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      try {
        await _firestore.collection('tech_employees').doc(userId).update({
          'profileImage': base64Image,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        //
      }
    } catch (e) {
      //
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('Error')
            ? Colors.red.shade800
            : Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_profileData?['profileImage'] != null &&
        _profileData!['profileImage'].toString().isNotEmpty) {
      try {
        final base64Image = _profileData!['profileImage'] as String;
        return Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: MemoryImage(base64Decode(base64Image)),
            ),
            _buildCameraIcon(),
          ],
        );
      } catch (e) {
        return _buildDefaultAvatar();
      }
    }
    return _buildDefaultAvatar();
  }

  Widget _buildCameraIcon() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.green.shade100,
          child: Icon(Icons.person, size: 35, color: Colors.green.shade800),
        ),
        _buildCameraIcon(),
      ],
    );
  }

  void _navigateToDetailScreen(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminDetailScreen(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomBar(text: "Profile"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: _buildProfileImage(),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "${_profileData?['firstName'] ?? 'LA Digital'} ${_profileData?['lastName'] ?? 'Agency'}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "bold",
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _profileData?['role'] ?? 'Owner',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "poppins",
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: [
                      _buildListTile(
                        icon: Icons.business,
                        title: "LA Digital Agency",
                        subtitle: "Company Owner",
                      ),
                      _buildListTile(
                        icon: Icons.email,
                        title: "Email",
                        subtitle: _auth.currentUser?.email ?? "LA@gmail.com",
                      ),
                      _buildListTile(
                        icon: Icons.location_on,
                        title: "Address",
                        subtitle: "Model Town, Lahore",
                      ),
                      _buildListTile(
                        icon: Icons.phone,
                        title: "Contact",
                        subtitle: "+92 300 1234567",
                      ),
                      _buildListTile(
                        icon: Icons.people,
                        title: "Team Management",
                        subtitle: "Manage employees & tasks",
                      ),
                      _buildListTile(
                        icon: Icons.work,
                        title: "Project Oversight",
                        subtitle: "Monitor all projects",
                      ),
                      _buildListTile(
                        icon: Icons.analytics,
                        title: "Performance Reviews",
                        subtitle: "Employee evaluations",
                      ),
                      _buildListTile(
                        icon: Icons.settings,
                        title: "Settings",
                        subtitle: "App configuration",
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () => _navigateToDetailScreen(title),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.green.shade700, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: "bold",
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            fontFamily: "poppins",
            color: Colors.grey.shade600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
