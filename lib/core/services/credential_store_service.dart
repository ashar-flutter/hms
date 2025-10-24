import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyProfileCompleted = 'profileCompleted';
  static const _keyFirstName = 'firstName';
  static const _keyLastName = 'lastName';
  static const _keyUid = 'uid';

  // Save user login state
  static Future<void> saveLoginState(bool value) async {
    await _storage.write(key: _keyIsLoggedIn, value: value.toString());
  }

  // Save profile completion state
  static Future<void> saveProfileCompleted(bool value) async {
    await _storage.write(key: _keyProfileCompleted, value: value.toString());
  }

  static Future<void> saveFirstName(String firstName) async {
    await _storage.write(key: _keyFirstName, value: firstName);
  }

  static Future<void> saveLastName(String lastName) async {
    await _storage.write(key: _keyLastName, value: lastName);
  }

  static Future<String?> getFirstName() async {
    return await _storage.read(key: _keyFirstName);
  }

  static Future<String?> getLastName() async {
    return await _storage.read(key: _keyLastName);
  }

  // ✅ Added UID handlers
  static Future<void> saveUid(String uid) async {
    await _storage.write(key: _keyUid, value: uid);
  }

  static Future<String?> getUid() async {
    return await _storage.read(key: _keyUid);
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
