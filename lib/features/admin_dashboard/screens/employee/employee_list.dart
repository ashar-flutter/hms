import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'employee_detail.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
          ),
          centerTitle: true,
          title: const Text(
            "Tech Employees",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "bold",
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tech_employees').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "poppins",
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No employees found",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: "poppins",
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Employees will appear here after they accept terms",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: "poppins",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final employees = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index].data() as Map<String, dynamic>;
              final employeeId = employees[index].id;

              return _buildEmployeeCard(employee, employeeId, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> employee, String employeeId, BuildContext context) {
    final firstName = employee['firstName'] ?? '';
    final lastName = employee['lastName'] ?? '';
    final fullName = '$firstName $lastName'.trim();
    final role = employee['role'] ?? 'Employee';
    final profileImage = employee['profileImage'];
    final joinedAt = employee['joinedAt'] != null
        ? _formatDate((employee['joinedAt'] as Timestamp).toDate())
        : 'Recently';
    final email = employee['email'] ?? 'No email';
    ImageProvider? avatar;
    if (profileImage != null && profileImage.isNotEmpty) {
      try {
        final imageBytes = base64Decode(profileImage);
        avatar = MemoryImage(imageBytes);
      } catch (e) {
        avatar = null;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmployeeDetailScreen(employeeId: employeeId),
            ),
          );
        },
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: avatar,
          backgroundColor: Colors.deepPurple.shade100,
          child: avatar == null
              ? const Icon(Icons.person, color: Colors.deepPurple, size: 20)
              : null,
        ),
        title: Text(
          fullName.isNotEmpty ? fullName : 'Unnamed Employee',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: "bold",
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              role,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: "poppins",
                color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              email,
              style: TextStyle(
                fontSize: 10,
                fontFamily: "poppins",
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Joined: $joinedAt",
              style: TextStyle(
                fontSize: 10,
                fontFamily: "poppins",
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Text(
            "Active",
            style: TextStyle(
              fontSize: 10,
              fontFamily: "bold",
              color: Colors.green.shade700,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}