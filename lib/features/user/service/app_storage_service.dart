import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppStorageService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveTermsAccepted() async {
    await _storage.write(key: 'terms_accepted', value: 'true');
  }

  static Future<bool> isTermsAccepted() async {
    final value = await _storage.read(key: 'terms_accepted');
    return value == 'true';
  }

  static Future<void> clearAllData() async {
    await _storage.deleteAll();
  }
}