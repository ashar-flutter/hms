import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../chats/widgets/custom_bar.dart';
import '../../../profile/controller/profile_controller.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final ProfileController _profileController = ProfileController();
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profileData = await _profileController.getCurrentUserProfile();
      setState(() {
        _profileData = profileData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildProfileImage() {
    if (_profileData?['profileImage'] != null) {
      try {
        final base64Image = _profileData!['profileImage'] as String;
        return CircleAvatar(
          radius: 60,
          backgroundImage: MemoryImage(base64Decode(base64Image)),
        );
      } catch (e) {
        return _buildDefaultAvatar();
      }
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.deepPurple.shade100,
      child: Icon(Icons.person, size: 50, color: Colors.deepPurple.shade800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomBar(text: "Profile"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                 SizedBox(height: AppBar().preferredSize.height/2),
                  Center(
                    child: Column(
                      children: [
                        _buildProfileImage(),
                        const SizedBox(height: 20),
                        Text(
                          "${_profileData?['firstName'] ?? ''} ${_profileData?['lastName'] ?? ''}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: "bold"
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _profileData?['role'] ?? 'Admin',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "bold",
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppBar().preferredSize.height/2),

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
                                    Icons.admin_panel_settings,
                                    color: Colors.blue.shade800,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Admin Permissions",
                                    style: TextStyle(
                                      fontFamily: "bold",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildPermissionItem("User Management"),
                              _buildPermissionItem("Attendance Tracking"),
                              _buildPermissionItem("Leave Approvals"),
                              _buildPermissionItem("Performance Reviews"),
                              _buildPermissionItem("System Configuration"),
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
                              const Text(
                                "Contact Information",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "bold"
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildContactItem(
                                Icons.email,
                                "Email",
                                "LA@gmail.com",
                              ),
                              _buildContactItem(
                                Icons.location_on,
                                "Address",
                                "LA digital Agency, Model town Lahore",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppBar().preferredSize.height/2),
                ],
              ),
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
          Text(permission, style: const TextStyle(fontSize: 14,
          fontFamily: "poppins"
          )),
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
                style: TextStyle(fontSize: 12,
                    fontFamily: "poppins",
                    color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: "bold",
                  fontSize: 12,
                  color: Colors.black
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
