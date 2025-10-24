import 'package:flutter/material.dart';
import '../../../core/services/credential_store_service.dart';
import '../service/profile_service.dart';

class ProfileController {
  final ProfileService _service = ProfileService();

  Future<bool> saveProfile({
    required String firstName,
    required String lastName,
    required String role,
    required String imagePath,
  }) async {
    try {
      await _service.saveProfile(
        firstName: firstName,
        lastName: lastName,
        role: role,
        imagePath: imagePath,
      );

      debugPrint("Profile saved successfully with imagePath: $imagePath");

      await SecureStorageService.saveFirstName(firstName);
      await SecureStorageService.saveLastName(lastName);

      return true;
    } catch (e) {
      debugPrint("Error saving profile: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> fetchProfile() async {
    return await _service.getProfile();
  }
}
