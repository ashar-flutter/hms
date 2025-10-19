import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'model/request_model.dart';

class RequestCard extends StatelessWidget {
  final RequestModel request;

  const RequestCard({super.key, required this.request});

  Widget buildFilePreview(String? filePath) {
    if (filePath == null || filePath.isEmpty) return const SizedBox.shrink();
    final file = File(filePath);
    if (!file.existsSync()) return const SizedBox.shrink();

    final extension = filePath.split('.').last.toLowerCase();

    if (["png", "jpg", "jpeg", "gif"].contains(extension)) {
      return GestureDetector(
        onTap: () => OpenFile.open(filePath),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
            image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => OpenFile.open(filePath),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              const Icon(Icons.insert_drive_file, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  filePath.split('/').last,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category: ${request.category}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: "bold",
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Type: ${request.type}",
              style: const TextStyle(fontFamily: "poppins"),
            ),
            const SizedBox(height: 4),
            Text(
              "Reason: ${request.reason}",
              style: const TextStyle(fontFamily: "poppins"),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "From: ${request.fromDate != null ? DateFormat('dd/MM/yyyy').format(request.fromDate!) : '-'}",
                  style: const TextStyle(fontFamily: "poppins"),
                ),
                const SizedBox(width: 15),
                Text(
                  "To: ${request.toDate != null ? DateFormat('dd/MM/yyyy').format(request.toDate!) : '-'}",
                  style: const TextStyle(fontFamily: "poppins"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Description: ${request.description}",
              style: const TextStyle(fontFamily: "poppins"),
            ),
            buildFilePreview(request.filePath),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: request.status == "Approved"
                    ? LinearGradient(
                        colors: [Colors.green.shade600, Colors.green.shade400],
                      )
                    : request.status == "Rejected"
                    ? LinearGradient(
                        colors: [Colors.red.shade600, Colors.red.shade400],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.orange.shade600,
                          Colors.orange.shade400,
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    request.status == "Approved"
                        ? Icons.check_circle
                        : request.status == "Rejected"
                        ? Icons.cancel
                        : Icons.hourglass_bottom,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    request.status ?? 'Submitted',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
