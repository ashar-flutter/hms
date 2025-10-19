import 'dart:io';

import 'package:flutter/material.dart';

import '../controller/upload_controller.dart';

class DottedBorderBox extends StatelessWidget {
  final File? file;
  final UploadController controller;
  const DottedBorderBox({super.key, this.file, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Upload",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          if (file != null) ...[
            Text(
              "File: ${file!.path.split('/').last} (${(file!.lengthSync()
                  / 1024).toStringAsFixed(2)} KB)",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontFamily: "poppins",
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => controller.clearFile(),
              child: Text(
                "Remove File",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade700,
                  fontFamily: "bold",
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ] else
            Text(
              "No file selected",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontFamily: "poppins",
              ),
            ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => controller.uploadFile(),
            child: Container(
              width: 160,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  "Upload File",
                  style: TextStyle(
                    fontFamily: "bold",
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
