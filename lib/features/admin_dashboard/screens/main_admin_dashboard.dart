import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/admin_dashboard/all_components/dashboard_card.dart';
import 'package:hr_flow/features/admin_dashboard/screens/employee/employee_list.dart';
import 'package:hr_flow/features/admin_dashboard/screens/employee_documents/employee_documents.dart';
import '../../chats/widgets/custom_bar.dart';
import '../../dashboard/documents/service/document_count_service.dart';
import '../all_components/refresh_tab.dart';
import '../services/request_count_service.dart';
import 'active_user/controllers/admin_attendance_controller.dart';
import 'active_user/screens/active_employees_screen.dart';
import 'get_request/admin_requests_screen.dart';

class MainAdminDashboard extends StatefulWidget {
  final String name;
  final String lName;
  const MainAdminDashboard({
    super.key,
    required this.name,
    required this.lName,
  });

  @override
  State<MainAdminDashboard> createState() => _MainAdminDashboardState();
}

class _MainAdminDashboardState extends State<MainAdminDashboard> {
  final RequestCountService countService = Get.put(RequestCountService());
  final DocumentCountService docCountService = Get.put(DocumentCountService());
  final AdminAttendanceController attendanceController = Get.put(
    AdminAttendanceController(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      countService.refreshCount();
      attendanceController.refreshData();
    });
  }

  void _navigateToRequests() {
    countService.markAsVisited();
    Get.to(() => AdminRequestsScreen());
  }

  void _navigateToActiveEmployees() {
    Get.to(() => ActiveEmployeesScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomBar(text: "Welcome ${widget.name} ${widget.lName}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height / 2),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/dashboard/company.jfif"),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "LA Digital Agency!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: "bold",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Welcome back! Here's your overview for today!",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: AppBar().preferredSize.height / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardCard(
                  onTap: () => Get.to(() => EmployeeList()),
                  text: "Employees",
                  imagePath: "assets/dashboard/employee_card_3d.svg",
                ),
                Obx(() {
                  final activeCount =
                      attendanceController.activeEmployeesCount.value;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      DashboardCard(
                        onTap: _navigateToActiveEmployees,
                        text: "Active Today",
                        imagePath: "assets/dashboard/active_employee_3d.svg",
                      ),
                      if (activeCount > 0)
                        Positioned(
                          top: -5,
                          right: -5,
                          child: GestureDetector(
                            onTap: _navigateToActiveEmployees,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen.shade900,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                activeCount > 9 ? '9+' : activeCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
            SizedBox(height: AppBar().preferredSize.height / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() {
                  final pendingCount = countService.pendingCount.value;
                  final shouldShow = countService.shouldShowCount;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      DashboardCard(
                        onTap: _navigateToRequests,
                        text: "Requests",
                        imagePath: "assets/dashboard/futuristic_leave_icon.svg",
                      ),
                      if (pendingCount > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: shouldShow ? Colors.red : Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Text(
                              pendingCount > 9 ? '9+' : pendingCount.toString(),
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
                  );
                }),

                Obx(() {
                  final docPendingCount = docCountService.pendingCount.value;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      DashboardCard(
                        onTap: () => Get.to(() => EmployeeDocuments()),
                        text: "Documents",
                        imagePath: "assets/dashboard/heavy_document_icon.svg",
                      ),
                      if (docPendingCount > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Text(
                              docPendingCount > 9
                                  ? '9+'
                                  : docPendingCount.toString(),
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
                  );
                }),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: RefreshFab(
        onRefresh: () async {
          await countService.refreshCount();
          await attendanceController.refreshData();
        },
      ),
    );
  }
}
