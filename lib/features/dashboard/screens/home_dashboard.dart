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
      backgroundColor: Color(0xFFF8F9FA),
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
            Obx(
              () => Stack(
                children: [
                  Center(
                    child: IconButton(
                      icon: const Icon(
                        size: 22,
                        Icons.notifications,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Get.to(() => NotificationsScreen());
                      },
                    ),
                  ),
                  if (notificationController.unreadCount.value > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${notificationController.unreadCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
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
                      fontSize: 16,
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
                    imagePath: "assets/dashboard/futuristic_attendance_icon.svg",
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomCard(
                        onTap: () {
                          Get.to(() => Reports());
                        },
                        text: "Reports",
                        imagePath: "assets/dashboard/futuristic_reports_icon.svg",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomCard(
                        text: "Calendar",
                        imagePath: "assets/dashboard/futuristic_calendar_icon.svg",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppBar().preferredSize.height),
            ],
          ),
        ),
      ),
    );
  }
}
