import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _key = 'user_profile_image_base64';

  Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    final file = File(picked.path);
    final bytes = await file.readAsBytes();
    final encoded = base64Encode(bytes);
    await _storage.write(key: _key, value: encoded);
    return file;
  }

  Future<File?> loadSavedImage() async {
    final encoded = await _storage.read(key: _key);
    if (encoded == null) return null;
    final bytes = base64Decode(encoded);
    final file = File('${Directory.systemTemp.path}/profile_image.png');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> clearImage() async {
    await _storage.delete(key: _key);
  }
}
