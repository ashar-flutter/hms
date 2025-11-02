import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class FileUploadService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFile() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file != null) {
        return File(file.path);
      }
    } catch (e) {}
    return null;
  }

  Future<File?> saveFileLocally(File file) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
          'uploaded_file_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String localPath = '${appDir.path}/$fileName';
      final File localFile = await file.copy(localPath);
      return localFile;
    } catch (e) {
      return file;
    }
  }

  Future<String?> getLastUploadedFilePath() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = await appDir.list().toList();

      for (FileSystemEntity file in files) {
        if (file.path.contains('uploaded_file_')) {
          return file.path;
        }
      }
    } catch (e) {}
    return null;
  }

  Future<void> clearStoredFile() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = await appDir.list().toList();

      for (FileSystemEntity file in files) {
        if (file.path.contains('uploaded_file_')) {
          await file.delete();
        }
      }
    } catch (e) {}
  }

  Future<Map<String, String>?> pickAndEncodeFile() async {
    try {
      final file = await pickFile();
      if (file != null) {
        final bytes = await File(file.path).readAsBytes();
        final base64String = base64Encode(bytes);
        final fileName = file.path.split('/').last;

        await saveFileLocally(file);

        return {
          'fileName': fileName,
          'base64Data': base64String,
          'filePath': file.path,
        };
      }
    } catch (e) {}
    return null;
  }

  Future<void> openBase64File(String base64Data, String fileName) async {
    try {
      final bytes = base64Decode(base64Data);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');

      await tempFile.writeAsBytes(bytes);

      final result = await OpenFile.open(tempFile.path);
    } catch (e) {}
  }
}
