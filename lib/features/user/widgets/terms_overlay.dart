import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hr_flow/core/services/credential_store_service.dart';
import '../service/app_storage_service.dart';
import '../service/employee_service.dart';

class TermsOverlay extends StatefulWidget {
  final VoidCallback onTermsAccepted;
  const TermsOverlay({super.key, required this.onTermsAccepted});
  @override
  State<TermsOverlay> createState() => _TermsOverlayState();
}

class _TermsOverlayState extends State<TermsOverlay> {
  String? _selectedRole;
  final List<String> _roles = [
    'Flutter Developer',
    'MERN Stack Developer',
    'Web Developer',
    'Java Developer',
    'React Native Developer',
    'UI/UX Designer',
    'Digital Marketer',
    'SEO Specialist',
    'Project Manager',
    'Content Writer',
  ];

  Future<void> _saveTermsAndRole() async {
    if (_selectedRole == null) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Please scroll down and select your role from dropdown',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        ),
      );
      return;
    }

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      // Update main users collection
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': _selectedRole,
        'termsAcceptedAt': FieldValue.serverTimestamp(),
      });

      final employeeService = EmployeeService();
      await employeeService.saveEmployeeData(
        firstName: userDoc.data()!['firstName'] ?? '',
        lastName: userDoc.data()!['lastName'] ?? '',
        role: _selectedRole!,
        profileImage: userDoc.data()!['profileImage'] ?? '',
      );

      await AppStorageService.saveTermsAccepted();
      if (mounted) {
        widget.onTermsAccepted();
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Error: $e',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        ),
      );
    }
  }

  Widget _buildOverlaySection(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: "bold",
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        ...points.map(
              (point) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              point,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: "poppins",
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.60,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.business,
                      color: Colors.deepPurple,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "LA Digital Agency",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "bold",
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                future: SecureStorageService.getFirstName(),
                builder: (context, snapshot) {
                  final userName = snapshot.data ?? 'User';
                  return Text(
                    "Welcome, $userName! 👋",
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "bold",
                      color: Colors.black,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              const Text(
                "Your responsibilities at LA Digital Agency:",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "poppins",
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOverlaySection("🏢 Company Services", [
                        "• Mobile App Development (Flutter, React Native)",
                        "• Web Development (React.js, Node.js, MERN)",
                        "• Social Media Marketing",
                        "• SEO & Digital Marketing",
                        "• Complete Digital Solutions",
                      ]),
                      const SizedBox(height: 16),
                      _buildOverlaySection("📋 Your Responsibilities", [
                        "• Mark attendance daily on time",
                        "• Apply for leaves in advance when needed",
                        "• Complete assigned tasks before deadlines",
                        "• Upload documents in admin section when assigned",
                        "• Maintain professional communication",
                        "• Follow company policies and procedures",
                        "• Report issues to management promptly",
                      ]),
                      const SizedBox(height: 16),
                      _buildOverlaySection("👨‍💼 Select Your Role", []),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedRole,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 8,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: "poppins",
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRole = newValue;
                              });
                            },
                            items: _roles.map<DropdownMenuItem<String>>((
                                String value,
                                ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(fontFamily: "poppins"),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue.shade700, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "By clicking 'Agree & Continue', you accept all company terms and conditions",
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontSize: 11,
                                  fontFamily: "poppins",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveTermsAndRole,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Agree & Continue to Profile",
                    style: TextStyle(
                      fontFamily: "bold",
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}