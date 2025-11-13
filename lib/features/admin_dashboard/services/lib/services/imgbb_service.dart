import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImgBBService {
  static final String apiKey = 'b8ea949c060edf41199e96df24d1afcd';

  static Future<String?> uploadFile(XFile file) async {
    try {
      print('🚀 Starting ImgBB upload for: ${file.name}');

      var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey')
      );

      List<int> fileBytes = await file.readAsBytes();
      print('📁 File size: ${fileBytes.length} bytes');

      request.files.add(http.MultipartFile.fromBytes(
        'image',
        fileBytes,
        filename: file.name,
      ));

      print('📤 Sending request to ImgBB...');
      var response = await request.send();
      print('📥 Response status: ${response.statusCode}');

      var responseData = await response.stream.bytesToString();
      print('📄 Response data: $responseData');

      var jsonData = jsonDecode(responseData);

      if (jsonData['success'] == true) {
        String fileUrl = jsonData['data']['url'];
        print('✅ ImgBB Upload SUCCESS: $fileUrl');
        return fileUrl;
      } else {
        print('❌ ImgBB Upload FAILED: ${jsonData['error']}');
        return null;
      }
    } catch (e) {
      print('💥 ImgBB Error: $e');
      return null;
    }
  }
}