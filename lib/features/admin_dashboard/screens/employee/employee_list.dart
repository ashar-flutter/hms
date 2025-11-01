import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:get/get.dart';
class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(size: 20, Icons.arrow_back),
          ),
          centerTitle: true,
          title: const Text(
            "Employees",
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
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'employee')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No employees found",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: "poppins",
                ),
              ),
            );
          }

          final employees = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index].data() as Map<String, dynamic>;
              final firstName = employee['firstName'] ?? '';
              final lastName = employee['lastName'] ?? '';
              final fullName = '$firstName $lastName'.trim();
              final profileImage = employee['profileImage'];

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
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: avatar,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: avatar == null
                        ? const Icon(
                      Icons.person,
                      color: Colors.white,
                    )
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
                  subtitle: const Text(
                    "employee",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}