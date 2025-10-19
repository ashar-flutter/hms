import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/dashboard/requests/request_card.dart';
import 'controller/status_controller.dart';

class RequestStatusScreen extends StatelessWidget {
  final RequestStatusController controller =
      Get.find<RequestStatusController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(size: 20, Icons.arrow_back),
          ),
          centerTitle: true,
          title: const Text(
            "Request status",
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
        if (controller.requests.isEmpty) {
          return const Center(
            child: Text("No requests yet", style: TextStyle(fontSize: 16)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          itemCount: controller.requests.length,
          itemBuilder: (context, index) {
            final request = controller.requests[index];
            return RequestCard(request: request);
          },
        );
      }),
    );
  }
}
