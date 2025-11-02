import 'dart:io';
import 'package:get/get.dart';
import '../../../../core/services/file_upload_service.dart';

class UploadController extends GetxController {
  final FileUploadService _uploadService = FileUploadService();

  Rx<File?> selectedFile = Rx<File?>(null);
  RxBool isUploading = false.obs;

  Future<void> uploadFile() async {
    try {
      isUploading.value = true;

      final file = await _uploadService.pickFile();
      if (file != null) {
        final savedFile = await _uploadService.saveFileLocally(file);
        selectedFile.value = savedFile;
      }
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> loadLastFile() async {
    final path = await _uploadService.getLastUploadedFilePath();
    if (path != null) {
      selectedFile.value = File(path);
    }
  }

  Future<void> clearFile() async {
    selectedFile.value = null;
    await _uploadService.clearStoredFile();
  }
  Future<Map<String, String>?> getFileBase64Data() async {
    if (selectedFile.value != null) {
      try {
        final fileInfo = await _uploadService.pickAndEncodeFile();
        return fileInfo;
      } catch (e) {
        print('❌ Error getting base64 data: $e');
      }
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    loadLastFile();
  }
}