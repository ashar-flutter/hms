import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  Future<List<Map<String, dynamic>>> getUserReports() async {
    final currentUid = uid;
    if (currentUid == null) return [];

    final snapshot = await _firestore
        .collection('attendance')
        .doc(currentUid)
        .collection('records')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'date': data['date'],
        'checkInTime': data['checkInTime'],
        'checkOutTime': data['checkOutTime'],
        'workDuration': data['workDuration'],
        'breakDuration': data['breakDuration'],
        'status': data['status'],
      };
    }).toList();
  }
}