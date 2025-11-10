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
      'breakDuration': breakDuration,
      'status': status,
      'location': {
        'lat': lat,
        'lng': lng,
      },
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}