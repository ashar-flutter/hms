import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hr_flow/features/user/widgets/custom_tile.dart';
import '../../chats/widgets/custom_bar.dart';
import 'dart:convert';
import '../widgets/custom_dialogue.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildProfileImage() {
    if (userData == null) {
      return Icon(
        Icons.person,
        size: 60,
        color: Colors.grey.shade600,
      );
    }

    final base64Image = userData!['profileImage'];

    if (base64Image == null || base64Image.isEmpty) {
      return Icon(
        Icons.person,
        size: 60,
        color: Colors.grey.shade600,
      );
    }

    try {
      final imageBytes = base64Decode(base64Image);
      return ClipOval(
        child: Image.memory(
          imageBytes,
          fit: BoxFit.cover,
          width: 60,
          height: 60,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: 60,
              color: Colors.grey.shade600,
            );
          },
        ),
      );
    } catch (e) {
      return Icon(
        Icons.person,
        size: 60,
        color: Colors.grey.shade600,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: const CustomBar(text: "Profile"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
          ? const Center(child: Text("No user data found"))
          : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: _buildProfileImage(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${userData!['firstName']} ${userData!['lastName']}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "bold",
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "bold",
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomTile(
              title: "Personal info",
              leadingIcon: Icons.person_2_outlined,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomDialogBox(
                    title: "Name: ${userData!['firstName']} ${userData!['lastName']}",
                    description: "Role: ${userData!['role'] ?? 'employee'}",
                  ),
                );
              },
            ),
            CustomTile(
              title: "Job info",
              leadingIcon: Icons.shopping_bag,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
