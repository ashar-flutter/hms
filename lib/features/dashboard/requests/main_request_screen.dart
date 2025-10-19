import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/dashboard/requests/add_request_screen.dart';

import 'leave_card.dart';

class MainRequestScreen extends StatelessWidget {
  const MainRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
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
              "Requests",
              style: TextStyle(
                fontFamily: "bold",
                fontSize: 16,
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
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
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
        body: Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height / 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LeaveCard(
                    context,
                    label: "Leaves This Month",
                    count: "2",
                    icon: Icons.calendar_today,
                    gradient: [
                      Color(0xFF4A00E0),
                      Color(0xFF8E2DE2),
                      Color(0xFF00C6FF),
                    ],
                  ),
                  LeaveCard(
                    context,
                    label: "Leaves This Year",
                    count: "24",
                    icon: Icons.date_range,
                    gradient: [
                      Color(0xFF0F2027), // very dark teal
                      Color(0xFF2C5364), // deep teal
                      Color(0xFF11998E), //
                    ],
                  ),
                  LeaveCard(
                    context,
                    label: "Rejected Leaves",
                    count: "0",
                    icon: Icons.close,
                    gradient: [
                      Color(0xFFAA0000), // dark red
                      Color(0xFFFF0000), // bright red
                      Color(0xFFFFA500), //

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 25,
                spreadRadius: 4,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // transparent to show gradient
                  shadowColor: Colors.transparent, // shadow handled by DecoratedBox
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  Get.to(AddRequestScreen());
                },
                child: const Text(
                  "Add Request",
                  style: TextStyle(
                    fontFamily: "bold",
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),


      ),
    );
  }
}
