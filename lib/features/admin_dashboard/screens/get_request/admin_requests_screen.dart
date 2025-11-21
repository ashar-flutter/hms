import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_flow/features/dashboard/requests/controller/status_controller.dart';
import 'package:hr_flow/features/dashboard/requests/model/request_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/snackbar/custom_snackbar.dart';
import '../../../history/history_service.dart';
import '../../services/file_open_service.dart';

class AdminRequestsScreen extends StatelessWidget {
  final RequestStatusController controller = Get.put(RequestStatusController());
  final FileOpenService fileOpenService = FileOpenService();

  AdminRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.12),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: AppBar(
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            title: const Text(
              "Employee Requests",
              style: TextStyle(
                fontFamily: "bold",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final allRequests = controller.getAllRequests();

        if (allRequests.isEmpty) {
          return _buildEmptyState();
        }

        return _buildRequestsList(allRequests);
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 50,
              color: Colors.blue[300],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No Requests Yet",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Employees haven't submitted any requests",
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList(List<RequestModel> requests) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildRequestCard(request, context);
      },
    );
  }

  Widget _buildRequestCard(RequestModel request, BuildContext context) {
    final statusInfo = _getStatusInfo(request.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(request, statusInfo),
            const SizedBox(height: 16),
            _buildRequestDetails(request),
            const SizedBox(height: 16),
            if (request.description.isNotEmpty) _buildDescription(request),
            if (request.filePath != null && request.filePath!.isNotEmpty)
              _buildFileAttachment(request),
            if (request.status == 'pending')
              _buildActionButtons(request, context),
            if (request.status != 'pending')
              _buildStatusMessage(request.status),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(RequestModel request, _StatusInfo statusInfo) {
    return Row(
      children: [
        _buildProfileAvatar(request),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${request.userFirstName} ${request.userLastName}'.trim(),
                style: const TextStyle(
                  fontFamily: "bold",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              if (request.userEmail.isNotEmpty) ...[
                Text(
                  request.userEmail,
                  style: TextStyle(
                    fontFamily: "poppins",
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              if (request.userRole.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  'Role: ${request.userRole}',
                  style: TextStyle(
                    fontFamily: "poppins",
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusInfo.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusInfo.color, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusInfo.icon, size: 14, color: statusInfo.color),
              const SizedBox(width: 6),
              Text(
                statusInfo.text,
                style: TextStyle(
                  fontFamily: "bold",
                  color: statusInfo.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar(RequestModel request) {
    if (request.userProfileImage != null &&
        request.userProfileImage!.isNotEmpty) {
      try {
        final imageBytes = base64.decode(request.userProfileImage!);
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue.shade200, width: 2),
          ),
          child: ClipOval(
            child: Image.memory(
              imageBytes,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultAvatar();
              },
            ),
          ),
        );
      } catch (e) {
        return _buildDefaultAvatar();
      }
    } else {
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
      child: Icon(Icons.person_rounded, color: Colors.blue[600], size: 24),
    );
  }

  Widget _buildRequestDetails(RequestModel request) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        children: [
          _buildDetailItem(
            "Category",
            request.category,
            Icons.category_outlined,
          ),
          const SizedBox(height: 12),
          _buildDetailItem(
            "Type",
            request.type,
            Icons.format_list_bulleted_outlined,
          ),
          const SizedBox(height: 12),
          _buildDetailItem(
            "Reason",
            request.reason,
            Icons.info_outline_rounded,
          ),
          const SizedBox(height: 12),
          if (request.fromDate != null)
            _buildDetailItem(
              "From Date",
              "${request.fromDate!.day.toString().padLeft(2, '0')}/${request.fromDate!.month.toString().padLeft(2, '0')}/${request.fromDate!.year}",
              Icons.calendar_today_outlined,
            ),
          if (request.fromDate != null) const SizedBox(height: 12),
          if (request.toDate != null)
            _buildDetailItem(
              "To Date",
              "${request.toDate!.day.toString().padLeft(2, '0')}/${request.toDate!.month.toString().padLeft(2, '0')}/${request.toDate!.year}",
              Icons.calendar_today_outlined,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF667EEA).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF667EEA)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: "bold",
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: "poppins",
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(RequestModel request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          "Description",
          style: TextStyle(
            fontFamily: "bold",
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
          ),
          child: Text(
            request.description,
            style: const TextStyle(
              fontFamily: "poppins",
              fontSize: 14,
              color: Color(0xFF0369A1),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileAttachment(RequestModel request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          "Attached File",
          style: TextStyle(
            fontFamily: "bold",
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _openFile(request),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.insert_drive_file_rounded,
                    color: Colors.blue[700],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileOpenService.getFileName(request.filePath!),
                        style: TextStyle(
                          fontFamily: "bold",
                          fontSize: 14,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to view file',
                        style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 12,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.blue[700],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(RequestModel request, BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.approveRequest(request.id);
                  HistoryService.updateHistoryStatus(request.id, 'approved');
                  CustomSnackBar.show(
                    title: "Approved",
                    message: "Request has been approved",
                    backgroundColor: const Color.fromARGB(255, 0, 122, 255),
                    textColor: Colors.black,
                    shadowColor: Colors.lightBlueAccent,
                    borderColor: Colors.transparent,
                    icon: Iconsax.message_tick,
                  );
                },
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text(
                  "Approve",
                  style: TextStyle(fontFamily: "bold", fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.rejectRequest(request.id);
                  HistoryService.updateHistoryStatus(request.id, 'rejected');
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
                icon: const Icon(Icons.close_rounded, size: 18),
                label: const Text(
                  "Reject",
                  style: TextStyle(fontFamily: "bold", fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusMessage(String status) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getStatusInfo(status).color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _getStatusInfo(status).color, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getStatusInfo(status).icon,
                size: 16,
                color: _getStatusInfo(status).color,
              ),
              const SizedBox(width: 8),
              Text(
                'Request already $status',
                style: TextStyle(
                  fontFamily: "bold",
                  fontSize: 14,
                  color: _getStatusInfo(status).color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _StatusInfo _getStatusInfo(String status) {
    switch (status) {
      case 'approved':
        return _StatusInfo(
          color: const Color(0xFF10B981),
          icon: Icons.check_circle_rounded,
          text: 'Approved',
        );
      case 'rejected':
        return _StatusInfo(
          color: const Color(0xFFEF4444),
          icon: Icons.cancel_rounded,
          text: 'Rejected',
        );
      default:
        return _StatusInfo(
          color: const Color(0xFFF59E0B),
          icon: Icons.pending_rounded,
          text: 'Pending',
        );
    }
  }

  void _openFile(RequestModel request) {
    final fileUrl = request.fileUrl ?? request.filePath;
    final fileName = request.fileName ?? 'Document';

    if (fileUrl != null && fileUrl.isNotEmpty) {
      if (fileUrl.toLowerCase().contains('.jpg') ||
          fileUrl.toLowerCase().contains('.jpeg') ||
          fileUrl.toLowerCase().contains('.png') ||
          fileUrl.toLowerCase().contains('.gif')) {
        Get.dialog(
          Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(40),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            fileName,
                            style: const TextStyle(
                              fontFamily: "bold",
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: Colors.black54,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Image Preview
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          fileUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          const Color(0xFF667EEA),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      "Loading Image...",
                                      style: TextStyle(
                                        fontFamily: "poppins",
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.error_outline_rounded,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Failed to load image",
                                    style: TextStyle(
                                      fontFamily: "bold",
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Please check the file URL",
                                    style: TextStyle(
                                      fontFamily: "poppins",
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Action Buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.back();
                              _launchInBrowser(fileUrl);
                            },
                            icon: const Icon(Icons.open_in_browser_rounded, size: 18),
                            label: const Text(
                              "Open in Browser",
                              style: TextStyle(fontFamily: "bold", fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF667EEA),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _copyToClipboard(fileUrl);
                            },
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            label: const Text(
                              "Copy Link",
                              style: TextStyle(fontFamily: "bold", fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF667EEA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Color(0xFF667EEA),
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
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
        // ... rest of the code same hai
        Get.dialog(
          AlertDialog(
            title: const Text("File Uploaded to Cloud"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("File: $fileName"),
                const SizedBox(height: 10),
                const Text("File is stored in cloud storage"),
                const SizedBox(height: 10),
                const Text("Admin can view this file online"),
                const SizedBox(height: 10),
                SelectableText(fileUrl, style: const TextStyle(fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text("OK")),
            ],
          ),
        );
      }
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text("File Info"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("File: $fileName"),
              const SizedBox(height: 10),
              Text("Path: ${request.filePath}"),
              const SizedBox(height: 10),
              const Text("Status: File saved locally"),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("OK")),
          ],
        ),
      );
    }
  }

  Future<void> _launchInBrowser(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Browser error: $e');
      }
    }
  }

  void _copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      Get.back();
    } catch (e) {
      // silent fail
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
      // silent fail
    }
  }
}

class _StatusInfo {
  final Color color;
  final IconData icon;
  final String text;

  _StatusInfo({required this.color, required this.icon, required this.text});
}
