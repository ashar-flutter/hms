import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> saveCheckStatus({
    required String date,
    required String? checkInTime,
    required String? checkOutTime,
    required String workDuration,
    required String breakDuration,
    required String status,
    required double lat,
    required double lng,
  }) async {
    final currentUid = uid;
    if (currentUid == null) return;

    final userDoc = await _firestore.collection('users').doc(currentUid).get();
    final userData = userDoc.data() ?? {};

    // 🎯 CRITICAL FIX: BREAK DURATION OVERWRITE SE BACHANE KE LIYE
    final existingDoc = await _firestore
        .collection('attendance')
        .doc(currentUid)
        .collection('records')
        .doc(date)
        .get();

    String finalBreakDuration = breakDuration;

    // Agar existing document hai aur usme break duration already hai
    if (existingDoc.exists) {
      final existingData = existingDoc.data();
      final existingBreakDuration = existingData?['breakDuration'] as String?;

      // Agar existing break duration zero nahi hai aur new break duration zero hai
      // Toh existing break duration ko preserve karo
      if (existingBreakDuration != null &&
          existingBreakDuration != "00:00:00" &&
          breakDuration == "00:00:00") {
        finalBreakDuration = existingBreakDuration;
      }
    }

    await _firestore
        .collection('attendance')
        .doc(currentUid)
        .collection('records')
        .doc(date)
        .set({
      'userId': currentUid,
      'firstName': userData['firstName'] ?? '',
      'lastName': userData['lastName'] ?? '',
      'role': userData['role'] ?? 'employee',
      'date': date,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'workDuration': workDuration,
      'breakDuration': finalBreakDuration,
      'status': status,
      'location': {
        'lat': lat,
        'lng': lng,
      },
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}