import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyProfileCompleted = 'profileCompleted';

  // Save user login state
  static Future<void> saveLoginState(bool value) async {
    await _storage.write(key: _keyIsLoggedIn, value: value.toString());
  }

  // Save profile completion state
  static Future<void> saveProfileCompleted(bool value) async {
    await _storage.write(key: _keyProfileCompleted, value: value.toString());
  }

  // Read states
  static Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: _keyIsLoggedIn);
    return value == 'true';
  }

  static Future<bool> isProfileCompleted() async {
    final value = await _storage.read(key: _keyProfileCompleted);
    return value == 'true';
  }

  // Clear data (for logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
