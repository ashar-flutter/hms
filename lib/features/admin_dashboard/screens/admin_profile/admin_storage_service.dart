import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminStorageService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveAdminProfile(Map<String, dynamic> profile) async {
    try {
      String profileString = _convertMapToString(profile);
      await _storage.write(key: 'admin_profile', value: profileString);
    } catch (e) {
      // Handle error silently
    }
  }

  static Future<Map<String, dynamic>?> getAdminProfile() async {
    try {
      String? data = await _storage.read(key: 'admin_profile');
      if (data != null) {
        return _convertStringToMap(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearAdminProfile() async {
    await _storage.delete(key: 'admin_profile');
  }

  static String _convertMapToString(Map<String, dynamic> map) {
    return '${map['firstName']}|${map['lastName']}|${map['role']}|${map['profileImage'] ?? ''}';
  }

  static Map<String, dynamic> _convertStringToMap(String data) {
    List<String> parts = data.split('|');
    return {
      'firstName': parts.isNotEmpty ? parts[0] : 'LA Digital',
      'lastName': parts.length > 1 ? parts[1] : 'Agency',
      'role': parts.length > 2 ? parts[2] : 'Owner',
      'profileImage': parts.length > 3 && parts[3].isNotEmpty ? parts[3] : null,
    };
  }
}