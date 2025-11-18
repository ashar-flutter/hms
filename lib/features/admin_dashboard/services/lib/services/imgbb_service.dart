import 'dart:convert';
import 'dart:async'; // ✅ ADD THIS IMPORT
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImgBBService {
  static final String apiKey = '26b749e32aa255c161b75a57a50c2074';

  static Future<String?> uploadFile(XFile file) async {
    try {
      print('🚀 Starting ImgBB upload...');

      // ✅ READ FILE AS BYTES
      List<int> fileBytes = await file.readAsBytes();

      // ✅ CREATE MULTIPART REQUEST
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api.imgbb.com/1/upload')
      );

      // ✅ ADD API KEY AS FIELD
      request.fields['key'] = apiKey;

      // ✅ ADD FILE
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          fileBytes,
          filename: 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );

      print('📤 Sending request to ImgBB...');

      // ✅ SEND REQUEST WITH TIMEOUT
      var response = await request.send().timeout(
        Duration(seconds: 30),
        onTimeout: () {
          print('⏰ Request timeout');
          throw TimeoutException('ImgBB request timeout'); // ✅ Now works
        },
      );

      // ✅ GET RESPONSE
      var responseBody = await response.stream.bytesToString();
      print('📥 Response status: ${response.statusCode}');
      print('📄 Response body: $responseBody');

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(responseBody);

        if (jsonData['success'] == true) {
          String fileUrl = jsonData['data']['url'];
          print('✅ ImgBB Upload SUCCESS: $fileUrl');
          return fileUrl;
        } else {
          print('❌ ImgBB API Error: ${jsonData['error']}');
          return null;
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('💥 ImgBB Upload Failed: $e');
      return null;
    }
  }
}