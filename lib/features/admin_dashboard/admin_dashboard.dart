import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../dashboard/attendance/record/employee_attendance_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final usersRef = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.where('role', isNotEqualTo: 'admin').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No employees found"));
          }

          final employeeDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: employeeDocs.length,
            itemBuilder: (context, index) {
              final employee = employeeDocs[index];
              final firstName = employee['firstName'] ?? '';
              final lastName = employee['lastName'] ?? '';
              final role = employee['role'] ?? '';
              final profileImage = employee['profileImageUrl'];

              ImageProvider avatar;
              if (profileImage != null) {
                if (profileImage.startsWith('http')) {
                  avatar = NetworkImage(profileImage);
                } else {
                  avatar = FileImage(File(profileImage));
                }
              } else {
                avatar = const AssetImage('assets/default_user.png');
              }

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: (){

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmployeeAttendanceScreen(
                                uid: employee.id,
                                name: "$firstName $lastName",
                              ),
                            ),
                          );
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: avatar,
                        ),
                        title: Text(
                          "$firstName $lastName",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "bold"
                          ),
                        ),
                        subtitle: Text("Role: $role",
                        style: TextStyle(
                          fontFamily: "poppins"
                        ),
                        ),
                      ),

                      const SizedBox(height: 6),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('attendance')
                            .doc(employee.id)
                            .collection('records')
                            .orderBy('timestamp', descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context, attendanceSnapshot) {
                          if (attendanceSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }

                          if (!attendanceSnapshot.hasData ||
                              attendanceSnapshot.data!.docs.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "No attendance record yet",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          final record = attendanceSnapshot.data!.docs.first;
                          final data = record.data() as Map<String, dynamic>;

                          final date = data['date'] ?? '-';
                          final checkIn = data['checkInTime'] ?? '-';
                          final checkOut = data['checkOutTime'] ?? '-';
                          final status = data['status'] ?? '-';
                          final work = data['workDuration'] ?? '00:00:00';
                          final brk = data['breakDuration'] ?? '00:00:00';

                          Color statusColor;
                          if (status == "Checked In") {
                            statusColor = Colors.green;
                          } else if (status == "Checked Out") {
                            statusColor = Colors.red;
                          } else if (status == "On Break") {
                            statusColor = Colors.orange;
                          } else {
                            statusColor = Colors.blueGrey;
                          }

                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Working",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text("Date: $date"),
                                Text("Check In: $checkIn"),
                                Text("Check Out: $checkOut"),
                                Text("Work: $work   |   Break: $brk"),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
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
