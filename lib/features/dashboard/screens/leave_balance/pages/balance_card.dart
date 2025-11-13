import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/dashboard/screens/leave_balance/pages/leave_balance_details_screen.dart';

import '../service/leave_balance_service.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: LeaveBalanceService.getBalanceStream(),
      builder: (context, snapshot) {
        int currentBalance = 36;
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          currentBalance = data['annualBalance'] ?? 36;
        }

        return GestureDetector(
          onTap: () => Get.to(() => LeaveBalanceDetailsScreen()),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: 54,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFEFECFD),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 15),
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 25,
                      color: Colors.deepPurple.shade900,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Leave Balance",
                      style: TextStyle(
                        color: Colors.deepPurple.shade900,
                        fontFamily: "bold",
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "$currentBalance/36",
                      style: TextStyle(
                        color: Colors.deepPurple.shade900,
                        fontFamily: "bold",
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Colors.deepPurple.shade900,
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
