import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class EmployeeDetailScreen extends StatelessWidget {
  final String employeeId;

  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black,
          size: 18,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Employee Details",
          style: TextStyle(
            fontSize: 15,
            fontFamily: "bold",
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('tech_employees')
            .doc(employeeId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "Employee not found",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          final employee = snapshot.data!.data() as Map<String, dynamic>;
          return _buildEmployeeDetails(employee, context);
        },
      ),
    );
  }

  Widget _buildEmployeeDetails(
    Map<String, dynamic> employee,
    BuildContext context,
  ) {
    final joinedAt = employee['joinedAt'] != null
        ? DateFormat(
            'MMM dd, yyyy',
          ).format((employee['joinedAt'] as Timestamp).toDate())
        : 'Not available';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProfileImage(employee),
                const SizedBox(height: 20),
                Text(
                  "${employee['firstName']} ${employee['lastName']}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: "bold",
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purple.shade700],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    employee['role']?.toString().toUpperCase() ??
                        'ROLE NOT SET',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "bold",
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  employee['email'] ?? 'No email',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "poppins",
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Expertise Section
          _buildInfoCard("Area of Expertise", [
            Text(
              employee['expertise'] ?? 'Not specified',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "poppins",
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ], icon: Icons.work_outline),

          const SizedBox(height: 20),

          // Employment Details
          _buildInfoCard("Employment Details", [
            _buildDetailRow("Joined Date", joinedAt, Icons.calendar_today),
            _buildDetailRow(
              "Terms Status",
              "Accepted on ${DateFormat('MMM dd, yyyy').format((employee['termsAcceptedAt'] as Timestamp).toDate())}",
              Icons.verified,
            ),
            _buildDetailRow(
              "Status",
              employee['status'] ?? 'active',
              Icons.circle,
              color: Colors.green,
            ),
          ], icon: Icons.business_center),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileImage(Map<String, dynamic> employee) {
    if (employee['profileImage'] == null) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.deepPurple.shade100,
        child: const Icon(Icons.person, size: 45, color: Colors.deepPurple),
      );
    }

    try {
      final imageBytes = base64Decode(employee['profileImage']);
      return CircleAvatar(radius: 50, backgroundImage: MemoryImage(imageBytes));
    } catch (e) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.deepPurple.shade100,
        child: const Icon(Icons.person, size: 45, color: Colors.deepPurple),
      );
    }
  }

  Widget _buildInfoCard(String title, List<Widget> children, {IconData? icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.deepPurple, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "bold",
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    Color color = Colors.deepPurple,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "bold",
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
