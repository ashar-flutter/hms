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
    if (currentUid == null) {
      print('User not logged in');
      return;
    }

    await _firestore
        .collection('attendance')
        .doc(currentUid)
        .collection('records')
        .doc(date)
        .set({
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