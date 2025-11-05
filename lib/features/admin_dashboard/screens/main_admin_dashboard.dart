import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/admin_dashboard/all_components/dashboard_card.dart';
import 'package:hr_flow/features/admin_dashboard/screens/employee/employee_list.dart';
import 'package:hr_flow/features/admin_dashboard/screens/employee_documents/employee_documents.dart';
import '../../chats/widgets/custom_bar.dart';
import '../../dashboard/documents/service/document_count_service.dart';
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
  final DocumentCountService docCountService = Get.put(DocumentCountService());

  void _debugAdminCheck() async {
    print('=== ADMIN DEBUG START ===');

    final pendingDocs = await FirebaseFirestore.instance
        .collection('documents')
        .where('status', isEqualTo: 'pending')
        .get();
    print('Admin Pending documents: ${pendingDocs.docs.length}');

    for (var doc in pendingDocs.docs) {
      print('Pending Doc: ${doc.data()}');
    }

    print('=== ADMIN DEBUG END ===');
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      countService.refreshCount();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        countService.refreshCount();
        _debugAdminCheck();
      });
    });
  }

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
      body: SingleChildScrollView(
        child: Column(
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
                  icon: const Icon(Icons.person_2, color: Colors.white),
                  color: const Color(0xFF1E3A8A),
                ),
                DashboardCard(
                  title: "Active Today",
                  icon: const Icon(Icons.verified_user, color: Colors.white),
                  color: const Color(0xFF00FF00),
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
                    clipBehavior: Clip.none,
                    children: [
                      DashboardCard(
                        isPress: _navigateToRequests,
                        title: "Requests",
                        icon: const Icon(
                          Icons.history_outlined,
                          color: Colors.white,
                        ),
                        color: const Color(0xFFFF8C00),
                      ),
                      if (pendingCount > 0)
                        Positioned(
                          top: -5,
                          right: -5,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: shouldShow ? Colors.red : Colors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              pendingCount > 9 ? '9+' : pendingCount.toString(),
                              style: const TextStyle(
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
                  icon: const Icon(Icons.error_outline, color: Colors.white),
                  color: const Color(0xFF8B0000),
                ),
              ],
            ),
            const SizedBox(height: 20),Obx(() {
              final docPendingCount = docCountService.pendingCount.value;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  DashboardCard(
                    onTap: () {
                      Get.to(() => EmployeeDocuments());
                    },
                    title: "Documents",
                    icon: const Icon(Icons.file_copy_outlined, color: Colors.white),
                    color: const Color(0xFF87CEEB),
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
            }),
            SizedBox(height: AppBar().preferredSize.height / 2),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          countService.refreshCount();

        },
        backgroundColor: Colors.amberAccent,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
