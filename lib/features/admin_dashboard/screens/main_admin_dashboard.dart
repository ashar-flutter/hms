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

  static const double _appBarHeight = 70;
  static const double _sectionSpacing1 = _appBarHeight / 2; // 35
  static const double _sectionSpacing2 = _appBarHeight / 2; // 35

  void _navigateToEmployees() => Get.to(() => EmployeeList());
  void _navigateToDocuments() => Get.to(() => EmployeeDocuments());

  void _navigateToRequests() {
    countService.markAsVisited();
    Get.to(() => AdminRequestsScreen());
  }

  void _navigateToActiveEmployees() {
    Get.to(() => ActiveEmployeesScreen());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      countService.refreshCount();
      attendanceController.refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(_appBarHeight),
        child: CustomBar(text: "Welcome ${widget.name} ${widget.lName}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: _sectionSpacing1),
            _buildCompanyLogo(),
            const SizedBox(height: 20),
            _buildWelcomeText(),
            const SizedBox(height: 10),
            _buildSubtitleText(),
            const SizedBox(height: _sectionSpacing2),
            _buildFirstRowCards(),
            const SizedBox(height: _sectionSpacing2),
            _buildSecondRowCards(),
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

  Widget _buildCompanyLogo() {
    return Container(
      height: 100,
      width: 100,
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage("assets/dashboard/company.jfif"),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Padding(
      padding: EdgeInsets.only(left: 15),
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
    );
  }

  Widget _buildSubtitleText() {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        "Welcome back! Here's your overview for today!",
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFirstRowCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DashboardCard(
          onTap: _navigateToEmployees,
          text: "Employees",
          imagePath: "assets/dashboard/employee_card_3d.svg",
        ),
        _buildActiveEmployeesCard(),
      ],
    );
  }

  Widget _buildActiveEmployeesCard() {
    return Obx(() {
      final activeCount = attendanceController.activeEmployeesCount.value;

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
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x42000000), // ✅ Pre-calculated
                        blurRadius: 4,
                        offset: Offset(0, 2),
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
    });
  }

  Widget _buildSecondRowCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_buildRequestsCard(), _buildDocumentsCard()],
    );
  }

  Widget _buildRequestsCard() {
    return Obx(() {
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
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
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
    });
  }

  // ✅ DOCUMENTS CARD - Single Obx
  Widget _buildDocumentsCard() {
    return Obx(() {
      final docPendingCount = docCountService.pendingCount.value;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          DashboardCard(
            onTap: _navigateToDocuments,
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
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  docPendingCount > 9 ? '9+' : docPendingCount.toString(),
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
    });
  }
}
