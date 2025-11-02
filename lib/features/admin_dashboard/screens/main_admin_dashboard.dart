import 'package:flutter/material.dart';
import 'package:hr_flow/features/admin_dashboard/all_components/dashboard_card.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/admin_dashboard/screens/employee/employee_list.dart';
import '../../chats/widgets/custom_bar.dart';
import '../services/request_count_service.dart';
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

  void _navigateToRequests() {
    countService.markAsVisited();
    Get.to(() => AdminRequestsScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomBar(text: "Welcome ${widget.name}${widget.lName}"),
      ),
      body: Column(
        children: [
          SizedBox(height: AppBar().preferredSize.height / 2),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Dashboard!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: "bold",
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Welcome back! Here's your overview for today!",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: AppBar().preferredSize.height / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardCard(
                isPress: () {
                  Get.to(() => EmployeeList());
                },
                title: " total employees",
                icon: Icon(Icons.person_2, color: Colors.white),
                color: Color(0xFF1E3A8A),
              ),
              DashboardCard(
                title: "Active Today",
                icon: Icon(Icons.verified_user, color: Colors.white),
                color: Color(0xFF00FF00),
              ),
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
                  children: [
                    DashboardCard(
                      isPress: _navigateToRequests,
                      title: "Requests",
                      icon: Icon(Icons.history_outlined, color: Colors.white),
                      color: Color(0xFFFF8C00),
                    ),
                    if (shouldShow)
                      Positioned(
                        top: 10,
                        right: 40,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            pendingCount > 9 ? '9+' : pendingCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
              DashboardCard(
                title: "Leave today",
                icon: Icon(Icons.error_outline, color: Colors.white),
                color: Color(0xFF8B0000),
              ),
            ],
          ),
        ],
      ),
    );
  }
}