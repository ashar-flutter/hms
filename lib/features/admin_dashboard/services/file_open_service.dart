import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
class FileOpenService {
  Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
    } catch (e) {
      _showFileOpenDialog(filePath);
    }
  }

  void _showFileOpenDialog(String filePath) {
    Get.dialog(
      AlertDialog(
        title: Text("File Open"),
        content: Text("File: ${getFileName(filePath)}"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  String getFileName(String filePath) {
    try {
      return filePath.split('/').last;
    } catch (e) {
      return 'Attached File';
    }
  }

  Future<void> openBase64File(String base64Data, String fileName) async {
    try {
      final bytes = base64Decode(base64Data);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');

      await tempFile.writeAsBytes(bytes);
      await OpenFile.open(tempFile.path);
    } catch (e) {
      _showFileOpenDialog(fileName);
    }
  }
}