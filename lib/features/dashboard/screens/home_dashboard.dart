import 'package:flutter/material.dart';
import 'package:hr_flow/features/dashboard/attendance/attendance_screen.dart';
import 'package:hr_flow/features/dashboard/documents/screens/main_document_page.dart';
import 'package:hr_flow/features/dashboard/reports/reports.dart';
import 'package:hr_flow/features/dashboard/requests/main_request_screen.dart';
import 'package:hr_flow/features/dashboard/screens/attendance_card.dart';
import 'package:hr_flow/features/dashboard/screens/custom_card.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/dashboard/screens/leave_balance/pages/balance_card.dart';
import 'package:hr_flow/features/dashboard/screens/request_notification_screen.dart';
import '../documents/service/user_document_status_service.dart';
import '../requests/controller/notification_controller.dart';

class HomeDashboard extends StatelessWidget {
  final String fName;
  final String lName;

  HomeDashboard({super.key, required this.fName, required this.lName});

  final NotificationController notificationController = Get.put(
    NotificationController(),
  );
  final UserDocumentStatusService documentStatusService = Get.put(
    UserDocumentStatusService(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      fName.isNotEmpty && lName.isNotEmpty
                          ? 'Welcome $fName $lName'
                          : 'Dashboard',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: Offset(0, 12),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Obx(
                () => Stack(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => NotificationsScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              size: 24,
                              Icons.notifications_outlined,
                              color: Color(0xFF374151),
                            ),

                            onPressed: () {
                              Get.to(() => NotificationsScreen());
                            },
                          ),
                        ),
                      ),
                    ),
                    if (notificationController.unreadCount.value > 0)
                      Positioned(
                        right: 6,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              '${notificationController.unreadCount.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: AppBar().preferredSize.height / 2),
              const AttendanceCard(),
              SizedBox(height: AppBar().preferredSize.height / 3),
              BalanceCard(),
              SizedBox(height: AppBar().preferredSize.height / 2),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "What would you like to do?",
                    style: TextStyle(
                      fontFamily: "bold",
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppBar().preferredSize.height / 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomCard(
                    onTap: () {
                      Get.to(() => AttendanceScreen());
                    },
                    text: "Attendance",
                    imagePath:
                        "assets/dashboard/futuristic_attendance_icon.svg",
                  ),
                  CustomCard(
                    onTap: () {
                      Get.to(() => MainRequestScreen());
                    },
                    text: "Requests",
                    imagePath: "assets/dashboard/futuristic_leave_icon.svg",
                  ),
                  Obx(() {
                    final responseCount =
                        documentStatusService.responseCount.value;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomCard(
                          onTap: () {
                            Get.to(() => MainDocumentPage());
                          },
                          text: "Documents",
                          imagePath: "assets/dashboard/heavy_document_icon.svg",
                        ),
                        if (responseCount > 0)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                responseCount > 9
                                    ? '9+'
                                    : responseCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomCard(
                    onTap: () {
                      Get.to(() => Reports());
                    },
                    text: "Reports",
                    imagePath: "assets/dashboard/futuristic_reports_icon.svg",
                  ),
                  CustomCard(
                    text: "Announce..",
                    imagePath: "assets/dashboard/announcements_icon_3d.svg",
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
