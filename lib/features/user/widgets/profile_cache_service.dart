import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileCacheService {
  static final ProfileCacheService _instance = ProfileCacheService._internal();
  factory ProfileCacheService() => _instance;
  ProfileCacheService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _profileKey = 'cached_profile_data';

  Future<void> cacheProfileData(Map<String, dynamic> profileData) async {
    try {
      final jsonString = _convertMapToJson(profileData);
      await _storage.write(key: _profileKey, value: jsonString);
    } catch (e) {
      // Cache fail silently
    }
  }

  Future<Map<String, dynamic>?> getCachedProfileData() async {
    try {
      final cachedData = await _storage.read(key: _profileKey);
      if (cachedData != null) {
        return _convertJsonToMap(cachedData);
      }
    } catch (e) {
      // If cache is corrupted, clear it
      await _storage.delete(key: _profileKey);
    }
    return null;
  }

  Future<void> clearCachedProfileData() async {
    await _storage.delete(key: _profileKey);
  }

  String _convertMapToJson(Map<String, dynamic> map) {
    return json.encode(map);
  }

  Map<String, dynamic> _convertJsonToMap(String jsonString) {
    return json.decode(jsonString) as Map<String, dynamic>;
  }
}