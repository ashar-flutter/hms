import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeeAttendanceScreen extends StatelessWidget {
  final String uid;
  final String name;

  const EmployeeAttendanceScreen({
    super.key,
    required this.uid,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final attendanceRef = FirebaseFirestore.instance
        .collection('attendance')
        .doc(uid)
        .collection('records')
        .orderBy('date', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$name's Attendance",
          style: const TextStyle(fontFamily: "bold"),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: attendanceRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No attendance records found.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: "poppins",
                ),
              ),
            );
          }

          final records = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final data = records[index].data() as Map<String, dynamic>;

              final date = data['date'] ?? '-';
              final checkIn = data['checkInTime'] ?? '-';
              final checkOut = data['checkOutTime'] ?? '-';
              final work = data['workDuration'] ?? '00:00:00';
              final brk = data['breakDuration'] ?? '00:00:00';
              final status = data['status'] ?? '-';

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
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.15),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "poppins",
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Check In", checkIn),
                        _buildInfoRow("Check Out", checkOut),
                        _buildInfoRow("Work Duration", work),
                        _buildInfoRow("Break Duration", brk),
                      ],
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "poppins",
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontFamily: "poppins")),
          ),
        ],
      ),
    );
  }
}
