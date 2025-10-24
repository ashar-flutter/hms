import 'package:flutter/material.dart';
import 'package:hr_flow/features/dashboard/attendance/attendance_screen.dart';
import 'package:hr_flow/features/dashboard/requests/main_request_screen.dart';
import 'package:hr_flow/features/dashboard/screens/custom_card.dart';
import 'package:get/get.dart';

class HomeDashboard extends StatelessWidget {
  final String fName;
  final String lName;

  const HomeDashboard({super.key, required this.fName, required this.lName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          title: Center(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  fName.isNotEmpty && lName.isNotEmpty
                      ? 'Welcome $fName $lName'
                      : 'Dashboard',
                  style: const TextStyle(
                    fontFamily: "bold",
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ],
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height / 2),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "What would you like to do?",
                  style: TextStyle(fontFamily: "bold", color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: AppBar().preferredSize.height / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomCard(
                  onTap: () {
                    Get.to(AttendanceScreen());
                  },
                  text: "Attendance",
                  imagePath: "assets/dashboard/attendance.png",
                ),
                CustomCard(
                  onTap: () {
                    Get.to(MainRequestScreen());
                  },
                  text: "Requests",
                  imagePath: "assets/dashboard/requests.png",
                ),
                CustomCard(
                  text: "Documents",
                  imagePath: "assets/dashboard/documents.png",
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomCard(
                  text: "Reports",
                  imagePath: "assets/dashboard/reports.png",
                ),
                CustomCard(
                  text: "Payroll",
                  imagePath: "assets/dashboard/payroll.png",
                ),
                CustomCard(
                  text: "Calendar",
                  imagePath: "assets/dashboard/calendar.png",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
