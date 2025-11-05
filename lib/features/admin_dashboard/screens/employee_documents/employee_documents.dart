import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_flow/features/dashboard/documents/service/document_count_service.dart';
import '../../../dashboard/documents/service/document_service.dart';
import '../../services/file_open_service.dart';

class EmployeeDocuments extends StatelessWidget {
  final DocumentService documentService = DocumentService();
  final DocumentCountService countService = Get.find<DocumentCountService>();
  final FileOpenService fileOpenService = FileOpenService();

  EmployeeDocuments({super.key});

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
            "Employee Documents",
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
      body: StreamBuilder<QuerySnapshot>(
        stream: documentService.getAllDocuments(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading documents'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No documents submitted yet",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final data = doc.data() as Map<String, dynamic>;
              return _buildDocumentCard(doc.id, data, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildDocumentCard(String docId, Map<String, dynamic> data, BuildContext context) {
    Color statusColor = Colors.orange;
    IconData statusIcon = Icons.pending;
    String statusText = 'Pending';

    if (data['status'] == 'approved') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Approved';
    } else if (data['status'] == 'rejected') {
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
                  ),
                  child: Icon(Icons.person, color: Colors.blue.shade700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['userEmail'] ?? 'Unknown User',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'User ID: ${data['userId']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        statusText,
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
            _buildDetailRow("Document Name", data['docName'] ?? 'N/A'),
            _buildDetailRow("Document Type", data['docType'] ?? 'N/A'),
            _buildDetailRow("Expiry Date", data['expiryDate'] ?? 'N/A'),
            _buildDetailRow("File Name", data['fileName'] ?? 'N/A'),
            if (data['filePath'] != null && data['filePath'].isNotEmpty) ...[
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
                  _openFile(data['filePath'], data['fileName']);
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
                              fileOpenService.getFileName(data['filePath']),
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
            if (data['adminResponse'] != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow("Admin Response", data['adminResponse']),
            ],
            if (data['status'] == 'pending') ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _respondToDocument(docId, 'approved', context),
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
                      onPressed: () => _respondToDocument(docId, 'rejected', context),
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
            width: 120,
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

  void _respondToDocument(String docId, String status, BuildContext context) async {
    try {
      final response = status == 'approved'
          ? 'Your document has been approved by admin'
          : 'Your document has been rejected by admin';

      await documentService.respondToDocument(
        docId: docId,
        status: status,
        adminResponse: response,
      );
    } catch (e) {}
  }

  void _openFile(String filePath, String fileName) {
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
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}