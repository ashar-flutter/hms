import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/dashboard/requests/request_card.dart';
import '../main_dashboard.dart';
import 'controller/status_controller.dart';

class RequestStatusScreen extends StatelessWidget {
  const RequestStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RequestStatusController controller =
    Get.find<RequestStatusController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          Get.offAll(() => MainDashboard(
            firstname: '',
            lastname: '',
          ));
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              "My Requests",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "bold",
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
          ),
        ),
        body: Obx(() {
          final userRequests = controller.getCurrentUserRequests();
          if (userRequests.isEmpty) {
            return const Center(
              child: Text(
                "No requests yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            itemCount: userRequests.length,
            itemBuilder: (context, index) {
              final request = userRequests[index];
              return RequestCard(request: request);
            },
          );
        }),
      ),
    );
  }
}