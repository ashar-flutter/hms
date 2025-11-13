import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:hr_flow/features/dashboard/requests/controller/status_controller.dart';
import 'package:hr_flow/features/dashboard/requests/model/request_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/snackbar/custom_snackbar.dart';
import '../../services/file_open_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRequestsScreen extends StatelessWidget {
  final RequestStatusController controller = Get.put(RequestStatusController());

  final FileOpenService fileOpenService = FileOpenService();

  AdminRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(size: 19, Icons.arrow_back),
          ),
          centerTitle: true,
          title: const Text(
            "All Requests",
            style: TextStyle(
              fontSize: 15,
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
        final allRequests = controller.getAllRequests();

        if (allRequests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 50, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No requests submitted yet",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: "bold",
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {},
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allRequests.length,
            itemBuilder: (context, index) {
              final request = allRequests[index];
              return _buildRequestCard(request, context);
            },
          ),
        );
      }),
    );
  }

  Widget _buildRequestCard(RequestModel request, BuildContext context) {
    Color statusColor = Colors.orange;
    IconData statusIcon = Icons.pending;
    String statusText = 'Pending';

    if (request.status == 'approved') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Approved';
    } else if (request.status == 'rejected') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
      statusText = 'Rejected';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade50,
                    image: request.userProfileImage != null
                        ? DecorationImage(
                            image: MemoryImage(
                              base64Decode(request.userProfileImage!),
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: request.userProfileImage == null
                      ? Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.blue.shade700,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${request.userFirstName} ${request.userLastName}'
                            .trim(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (request.userEmail.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          request.userEmail,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      if (request.userRole.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Role: ${request.userRole}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _buildDetailRow("Category", request.category),
            _buildDetailRow("Type", request.type),
            _buildDetailRow("Reason", request.reason),
            if (request.fromDate != null)
              _buildDetailRow(
                "From Date",
                "${request.fromDate!.day.toString().padLeft(2, '0')}/${request.fromDate!.month.toString().padLeft(2, '0')}/${request.fromDate!.year}",
              ),
            if (request.toDate != null)
              _buildDetailRow(
                "To Date",
                "${request.toDate!.day.toString().padLeft(2, '0')}/${request.toDate!.month.toString().padLeft(2, '0')}/${request.toDate!.year}",
              ),
            if (request.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                "Description:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  request.description,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
            if (request.filePath != null && request.filePath!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Attached File:",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  _openFile(
                    request.filePath!,
                    request.fileName,
                    request.fileData,
                    request.fileUrl,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fileOpenService.getFileName(request.filePath!),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Tap to view',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.open_in_new,
                        color: Colors.blue.shade700,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (request.status == 'pending') ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.approveRequest(request.id);
                        CustomSnackBar.show(
                          title: "Approved",
                          message: "Request has been approved",
                          backgroundColor: const Color.fromARGB(
                            255,
                            0,
                            122,
                            255,
                          ),
                          textColor: Colors.black,
                          shadowColor: Colors.lightBlueAccent,
                          borderColor: Colors.transparent,
                          icon: Iconsax.message_tick,
                        );
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text("Approve"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.rejectRequest(request.id);
                        _returnLeaveBalance(
                          request.id,
                          request.leaveCount,
                          request.userId,
                        );
                        CustomSnackBar.show(
                          title: "Rejection",
                          message: "request has been rejected",
                          backgroundColor: Colors.redAccent.shade400,
                          textColor: Colors.black,
                          shadowColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          icon: Iconsax.close_square,
                        );
                      },
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text("Reject"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (request.status != 'pending') ...[
              const SizedBox(height: 8),
              Text(
                'Request already ${request.status}',
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _openFile(
    String filePath,
    String? fileName,
    String? fileData,
    String? fileUrl,
  ) async {
    if (fileUrl != null && fileUrl.isNotEmpty) {
      // Agar image hai toh preview dikhao aur browser option do
      if (fileUrl.toLowerCase().contains('.jpg') ||
          fileUrl.toLowerCase().contains('.jpeg') ||
          fileUrl.toLowerCase().contains('.png') ||
          fileUrl.toLowerCase().contains('.gif')) {
        // Image preview with browser option
        Get.dialog(
          Dialog(
            child: Container(
              width: 350,
              height: 500,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Image Preview",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  // Image
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.network(
                        fileUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 40),
                                SizedBox(height: 10),
                                Text("Failed to load image"),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Buttons
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Browser mein open karein
                              _launchInBrowser(fileUrl);
                            },
                            icon: Icon(Icons.open_in_browser, size: 18),
                            label: Text("Open in Browser"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Link copy karein
                              _copyToClipboard(fileUrl);
                            },
                            icon: Icon(Icons.copy, size: 18),
                            label: Text("Copy Link"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        // Agar image nahi hai (PDF, Word, etc.) - PURANA SYSTEM BILKUL WAISA KA WAISA
        Get.dialog(
          AlertDialog(
            title: Text("File Uploaded to Cloud"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("File is stored in cloud storage"),
                SizedBox(height: 10),
                Text("Admin can view this file online"),
                SizedBox(height: 10),
                SelectableText(fileUrl, style: TextStyle(fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: Text("OK")),
            ],
          ),
        );
      }
    } else {
      // Agar fileUrl nahi hai - PURANA SYSTEM BILKUL WAISA KA WAISA
      Get.dialog(
        AlertDialog(
          title: Text("File Info"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("File: ${fileOpenService.getFileName(filePath)}"),
              SizedBox(height: 10),
              Text("Path: $filePath"),
              SizedBox(height: 10),
              Text("Status: File saved locally"),
            ],
          ),
          actions: [TextButton(onPressed: () => Get.back(), child: Text("OK"))],
        ),
      );
    }
  }

  Future<void> _launchInBrowser(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      //  - silent fail
    }
  }

  void _copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      Get.back();
    } catch (e) {
      // - silent fail
    }
  }

  void _returnLeaveBalance(
    String requestId,
    int leaveCount,
    String userId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('leave_balance')
          .doc(userId)
          .update({
            'annualBalance': FieldValue.increment(leaveCount),
            'usedLeaves': FieldValue.increment(-leaveCount),
            'monthlyUsed': FieldValue.increment(-leaveCount),
            'weeklyUsed': FieldValue.increment(-leaveCount),
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      //
    }
  }
}
