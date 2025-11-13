import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PerformanceController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  Future<List<Map<String, dynamic>>> getUserPerformanceData() async {
    final currentUid = uid;
    if (currentUid == null) return [];

    final snapshot = await _firestore
        .collection('attendance')
        .doc(currentUid)
        .collection('records')
        .orderBy('date', descending: true)
        .limit(30)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'date': data['date'],
        'workDuration': data['workDuration'] ?? '0:00',
        'checkInTime': data['checkInTime'],
        'checkOutTime': data['checkOutTime'],
        'status': data['status'],
      };
    }).toList();
  }
}