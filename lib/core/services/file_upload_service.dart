import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FileUploadService {
  final _secureStorage = const FlutterSecureStorage();

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<File> saveFileLocally(File file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newPath = '${appDir.path}/${file.uri.pathSegments.last}';
    final newFile = await file.copy(newPath);


    await _secureStorage.write(key: 'last_uploaded_file', value: newFile.path);

    return newFile;
  }

  Future<String?> getLastUploadedFilePath() async {
    return await _secureStorage.read(key: 'last_uploaded_file');
  }

  Future<void> clearStoredFile() async {
    await _secureStorage.delete(key: 'last_uploaded_file');
  }
}
