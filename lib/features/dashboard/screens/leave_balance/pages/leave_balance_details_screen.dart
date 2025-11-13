import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/leave_balance_service.dart';

class LeaveBalanceDetailsScreen extends StatelessWidget {
  const LeaveBalanceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Leave Balance",
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontFamily: "bold"
        ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back,
          size: 19,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: LeaveBalanceService.getBalanceStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic> data = {};
          if (snapshot.data!.exists) {
            data = snapshot.data!.data() as Map<String, dynamic>;
          }

          final annualBalance = data['annualBalance'] ?? 36;
          final usedLeaves = data['usedLeaves'] ?? 0;
          final monthlyUsed = data['monthlyUsed'] ?? 0;
          final weeklyUsed = data['weeklyUsed'] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Annual Balance",
                          style: TextStyle(fontFamily: "bold", fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "$annualBalance/36",
                          style: TextStyle(fontFamily: "bold", fontSize: 24),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Used: $usedLeaves leaves",
                          style: TextStyle(fontFamily: "poppins"),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Usage Limits",
                          style: TextStyle(fontFamily: "bold", fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Monthly",
                              style: TextStyle(fontFamily: "poppins"),
                            ),
                            Text(
                              "$monthlyUsed/3",
                              style: TextStyle(fontFamily: "bold"),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Weekly",
                              style: TextStyle(fontFamily: "poppins"),
                            ),
                            Text(
                              "$weeklyUsed/1",
                              style: TextStyle(fontFamily: "bold"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
