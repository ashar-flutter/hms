// lib/features/profile/service/profile_update_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileUpdateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateExistingProfiles() async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();

      for (final doc in usersSnapshot.docs) {
        await _firestore.collection('users').doc(doc.id).update({
          'userId': doc.id,
        });
      }

      print('All existing profiles updated with userId field');
    } catch (e) {
      print('Error updating profiles: $e');
    }
  }
}