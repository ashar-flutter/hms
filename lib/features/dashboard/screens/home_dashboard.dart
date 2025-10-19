import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hr_flow/features/dashboard/attendance/attendance_screen.dart';
import 'package:hr_flow/features/dashboard/requests/main_request_screen.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/fluent_emoji_high_contrast.dart';
import 'package:iconify_flutter/icons/mdi.dart';

import 'package:hr_flow/features/dashboard/screens/custom_card.dart';

class HomeDashboard extends StatelessWidget {
  final String fName;
  final String lName;

  const HomeDashboard({super.key, required this.fName, required this.lName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              elevation: 12,
              shadowColor: Colors.black.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppBar().preferredSize.height / 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomCard(
                          onTap: () {
                            Get.to(AttendanceScreen());
                          },
                          iconName: MaterialSymbols.fingerprint,
                          label: "Attendance",
                          gradientColors: const [
                            Color(0xFF6A11CB),
                            Color(0xFF2575FC),
                          ],
                        ),
                        CustomCard(
                          onTap: () {
                            Get.to(MainRequestScreen());
                          },
                          iconName: FluentEmojiHighContrast.page_facing_up,
                          label: "Requests",
                          gradientColors: const [
                            Color(0xFF2193B0),
                            Color(0xFF6DD5ED),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppBar().preferredSize.height / 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomCard(
                          iconName: Mdi.file_document_plus_outline,
                          label: "Reports",
                          gradientColors: const [
                            Color(0xFF11998E),
                            Color(0xFF38EF7D),
                          ],
                        ),
                        CustomCard(
                          iconName: Mdi.calendar_month_outline,
                          label: "Calendar",
                          gradientColors: const [
                            Color(0xFFFFD700),
                            Color(0xFFFFC107),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppBar().preferredSize.height / 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
