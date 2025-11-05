import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../chats/widgets/custom_bar.dart';
import 'dart:convert';

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
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildProfileImage() {
    if (userData == null) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.deepPurple.shade100,
        child: Icon(Icons.person, size: 50, color: Colors.deepPurple.shade800),
      );
    }

    final base64Image = userData!['profileImage'];

    if (base64Image == null || base64Image.isEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.deepPurple.shade100,
        child: Icon(Icons.person, size: 50, color: Colors.deepPurple.shade800),
      );
    }

    try {
      final imageBytes = base64Decode(base64Image);
      return CircleAvatar(radius: 60, backgroundImage: MemoryImage(imageBytes));
    } catch (e) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.deepPurple.shade100,
        child: Icon(Icons.person, size: 50, color: Colors.deepPurple.shade800),
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
          ? const Center(
              child: Text(
                "No user data found",
                style: TextStyle(fontFamily: "bold"),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: AppBar().preferredSize.height / 2),

                  Center(
                    child: Column(
                      children: [
                        _buildProfileImage(),
                        const SizedBox(height: 20),
                        Text(
                          "${userData!['firstName']} ${userData!['lastName']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "bold",
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            userData!['role'] ?? 'Employee',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "poppins",
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppBar().preferredSize.height / 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.work_history,
                                    color: Colors.blue.shade800,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Employee Details",
                                    style: TextStyle(
                                      fontFamily: "bold",
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildDetailItem("Type", "Engineer"),
                              _buildDetailItem("Department", "Software"),
                              _buildDetailItem("Position", "developer"),
                              _buildDetailItem("Employment Type", "Full-time"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.contact_page,
                                    color: Colors.green.shade800,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Contact Information",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: "bold",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildContactItem(
                                Icons.email,
                                "Work Email",
                                "${userData!['firstName']}.${userData!['lastName']}@company.com",
                              ),
                              _buildContactItem(
                                Icons.phone,
                                "Office Phone",
                                "+92 305 8490633",
                              ),
                              _buildContactItem(
                                Icons.location_on,
                                "Office Location",
                                "La digital agency, model town ",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.security,
                                    color: Colors.purple.shade800,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "permissions",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "bold",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildPermissionItem("Time Tracking"),
                              _buildPermissionItem("Leave Requests"),
                              _buildPermissionItem("Task Management"),
                              _buildPermissionItem("Team Communication"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppBar().preferredSize.height * 2),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontFamily: "poppins",
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 12, fontFamily: "bold")),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontFamily: "poppins",
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontFamily: "bold"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(String permission) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade600, size: 16),
          const SizedBox(width: 8),
          Text(
            permission,
            style: const TextStyle(fontSize: 14, fontFamily: "poppins"),
          ),
        ],
      ),
    );
  }
}
