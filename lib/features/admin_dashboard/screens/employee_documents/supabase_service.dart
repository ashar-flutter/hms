import 'package:supabase/supabase.dart';
import 'package:image_picker/image_picker.dart';

class SupabaseService {
  static final String supabaseUrl = 'https://osrslfojgfhmmbznnulb.supabase.co';
  static final String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9zcnNsZm9qZ2ZobW1iem5udWxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1ODYzODYsImV4cCI6MjA3OTE2MjM4Nn0.WEFUD4t1mygr6DmDah3KKZFTH-Ww3kyL8M0zHw6yauo';

  static final SupabaseClient supabase = SupabaseClient(supabaseUrl, supabaseAnonKey);

  static Future<String?> uploadFile(XFile file) async {
    try {
      print('🚀 Uploading to Supabase: ${file.name}');

      final fileBytes = await file.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

      await supabase.storage
          .from('documents')
          .uploadBinary(fileName, fileBytes);

      // ✅ GET PUBLIC URL
      final publicUrl = supabase.storage
          .from('documents')
          .getPublicUrl(fileName);

      print('✅ Supabase Upload SUCCESS: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('💥 Supabase Upload Failed: $e');
      return null;
    }
  }
}