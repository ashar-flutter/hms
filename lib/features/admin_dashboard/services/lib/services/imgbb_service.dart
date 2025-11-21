import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImgBBService {
  static final String apiKey = '26b749e32aa255c161b75a57a50c2074';

  static Future<String?> uploadFile(XFile file) async {
    try {
      print('🚀 Starting ImgBB upload for: ${file.name}');

      // ✅ READ FILE AS BYTES
      List<int> fileBytes = await file.readAsBytes();

      // ✅ CREATE BASE64 STRING
      String base64Image = base64Encode(fileBytes);

      print('📤 Sending Base64 request to ImgBB...');

      // ✅ CREATE REQUEST BODY
      var requestBody = {
        'key': apiKey,
        'image': base64Image,
      };

      // ✅ SEND POST REQUEST
      var response = await http.post(
        Uri.parse('https://api.imgbb.com/1/upload'),
        body: requestBody,
      ).timeout(Duration(seconds: 30));

      print('📥 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

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