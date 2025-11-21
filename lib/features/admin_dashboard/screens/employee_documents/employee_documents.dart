import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_flow/features/dashboard/documents/service/document_count_service.dart';
import '../../../dashboard/documents/service/document_service.dart';
import '../../services/file_open_service.dart';
import 'document_dialog_box.dart';

class EmployeeDocuments extends StatelessWidget {
  final DocumentService documentService = DocumentService();
  final DocumentCountService countService = Get.find<DocumentCountService>();
  final FileOpenService fileOpenService = FileOpenService();

  EmployeeDocuments({super.key});

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
              "Employee Documents",
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
      body: StreamBuilder<QuerySnapshot>(
        stream: documentService.getAllDocuments(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorState();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }
          final documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return _buildEmptyState();
          }
          return _buildDocumentsList(documents);
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Error loading documents",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading Documents...",
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
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
              Icons.folder_open_rounded,
              size: 50,
              color: Colors.blue[300],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No Documents Yet",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Employees haven't submitted any documents",
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

  Widget _buildDocumentsList(List<QueryDocumentSnapshot> documents) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        final data = doc.data() as Map<String, dynamic>;
        return _buildDocumentCard(doc.id, data, context);
      },
    );
  }

  Widget _buildDocumentCard(
    String docId,
    Map<String, dynamic> data,
    BuildContext context,
  ) {
    final statusInfo = _getStatusInfo(data['status']);

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
            _buildUserInfo(data, statusInfo),
            const SizedBox(height: 16),
            _buildDocumentDetails(data),
            const SizedBox(height: 16),
            if (data['filePath'] != null && data['filePath'].isNotEmpty)
              _buildFileAttachment(data),
            if (data['adminResponse'] != null)
              _buildAdminResponse(data['adminResponse']),
            if (data['status'] == 'pending')
              _buildActionButtons(docId, context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> data, _StatusInfo statusInfo) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserProfile(data['userId']),
      builder: (context, snapshot) {
        String userName = 'Unknown User';
        String? profileImage;

        if (snapshot.hasData && snapshot.data != null) {
          final profile = snapshot.data!;
          userName =
              '${profile['firstName'] ?? ''} ${profile['lastName'] ?? ''}'
                  .trim();
          if (userName.isEmpty) userName = data['userEmail'] ?? 'Unknown User';
          profileImage = profile['profileImage'];
        } else {
          userName = data['userEmail'] ?? 'Unknown User';
        }

        return Row(
          children: [
            _buildProfileAvatar(profileImage, userName),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontFamily: "bold",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'User ID: ${data['userId'] ?? 'N/A'}',
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
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
      },
    );
  }

  Widget _buildProfileAvatar(String? profileImage, String userName) {
    if (profileImage != null && profileImage.isNotEmpty) {
      try {
        final imageBytes = base64.decode(profileImage);
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
                return _buildDefaultAvatar(userName);
              },
            ),
          ),
        );
      } catch (e) {
        return _buildDefaultAvatar(userName);
      }
    } else {
      return _buildDefaultAvatar(userName);
    }
  }

  Widget _buildDefaultAvatar(String userName) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
      child: Icon(Icons.person_rounded, color: Colors.blue[600], size: 24),
    );
  }

  Widget _buildDocumentDetails(Map<String, dynamic> data) {
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
            "Document Name",
            data['docName'] ?? 'N/A',
            Icons.description_outlined,
          ),
          const SizedBox(height: 12),
          _buildDetailItem(
            "Document Type",
            data['docType'] ?? 'N/A',
            Icons.category_outlined,
          ),
          const SizedBox(height: 12),
          _buildDetailItem(
            "Submission Date",
            data['expiryDate'] ?? 'N/A',
            Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 12),
          _buildDetailItem(
            "File Name",
            data['fileName'] ?? 'N/A',
            Icons.attach_file_rounded,
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

  Widget _buildFileAttachment(Map<String, dynamic> data) {
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
          onTap: () => _openFile(data),
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
                        fileOpenService.getFileName(data['filePath']),
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

  Widget _buildAdminResponse(String response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          "Admin Response",
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
            response,
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

  Widget _buildActionButtons(String docId, BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _respondToDocument(docId, 'approved', context),
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
                onPressed: () => _respondToDocument(docId, 'rejected', context),
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

  Future<Map<String, dynamic>?> _getUserProfile(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) return doc.data();
      return null;
    } catch (e) {
      return null;
    }
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

  // ✅ ONLY ONE _openFile METHOD - Duplicate removed
  void _openFile(Map<String, dynamic> data) {
    final fileUrl = data['fileUrl'] ?? data['filePath']; // 'fileUrl' use karo
    final fileName = data['fileName'] ?? 'Document';

    if (fileUrl != null && fileUrl.isNotEmpty) {
      Get.dialog(DocumentDialogBox(fileUrl: fileUrl, fileName: fileName));
    } else {
      Get.snackbar(
        "Error",
        "File not available",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _respondToDocument(
    String docId,
    String status,
    BuildContext context,
  ) async {
    try {
      final response = status == 'approved'
          ? 'Your document has been approved by admin'
          : 'Your document has been rejected by admin';

      await documentService.respondToDocument(
        docId: docId,
        status: status,
        adminResponse: response,
      );
    } catch (e) {
      // Error handling remains same
    }
  }
}

class _StatusInfo {
  final Color color;
  final IconData icon;
  final String text;

  _StatusInfo({required this.color, required this.icon, required this.text});
}
