import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../service/leave_balance_service.dart';

class LeaveValidator {
  static Future<bool> validateLeaveRequest(int requestedLeaves) async {
    final balance = await LeaveBalanceService.getUserBalance();

    final annualBalance = balance['annualBalance'] ?? 36;
    final monthlyUsed = balance['monthlyUsed'] ?? 0;
    final weeklyUsed = balance['weeklyUsed'] ?? 0;

    if (weeklyUsed + requestedLeaves > 1) {
      Get.defaultDialog(
        titlePadding: EdgeInsets.only(top: 24),
        titleStyle: TextStyle(
          fontFamily: "bold",
          fontSize: 15,
          color: Colors.black,
        ),
        title: "Weekly Limit Exceeded",
        content: Text(
          "You can only take 1 leave per week.",
          style: TextStyle(fontSize: 13, fontFamily: "poppins"),
        ),
        confirm: ElevatedButton(
          onPressed: () => Get.back(),
          child: Text("OK", style: TextStyle(fontFamily: "bold")),
        ),
      );
      return false;
    }

    if (monthlyUsed + requestedLeaves > 3) {
      Get.defaultDialog(
        title: "Monthly Limit Exceeded",
        content: Text("You can only take 3 leaves per month."),
        confirm: ElevatedButton(onPressed: () => Get.back(), child: Text("OK")),
      );
      return false;
    }

    if (annualBalance < requestedLeaves) {
      Get.defaultDialog(
        title: "Insufficient Balance",
        content: Text("You don't have enough leaves."),
        confirm: ElevatedButton(onPressed: () => Get.back(), child: Text("OK")),
      );
      return false;
    }

    return true;
  }
}
