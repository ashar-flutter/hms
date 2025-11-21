import 'package:image_picker/image_picker.dart';
import 'supabase_service.dart';

class PDUploadService {
  static Future<String?> uploadFile(XFile file) async {
    return await SupabaseService.uploadFile(file);
  }
}