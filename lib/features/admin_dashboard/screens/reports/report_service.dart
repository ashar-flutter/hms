import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hr_flow/features/admin_dashboard/screens/reports/report_model.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create new report
  Future<void> createReport({
    required String title,
    required String type,
    required String message,
  }) async {
    final userId = _auth.currentUser!.uid;
    final reportRef = _firestore.collection('reports').doc();

    final report = Report(
      id: reportRef.id,
      title: title,
      type: type,
      message: message,
      createdAt: DateTime.now(),
      createdBy: userId,
      isActive: true,
    );

    await reportRef.set(report.toFirestore());

    // Distribute to all users
    await _distributeReportToUsers(reportRef.id);
  }

  // Distribute report to all users - FIXED VERSION
  Future<void> _distributeReportToUsers(String reportId) async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();
      print('👥 Distributing to ${usersSnapshot.docs.length} users'); // ✅ DEBUG

      final batch = _firestore.batch();

      for (final userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        final userReportRef = _firestore
            .collection('user_reports')
            .doc(userId)
            .collection('unread_reports')
            .doc(reportId);

        batch.set(userReportRef, {
          'isRead': false,
          'receivedAt': Timestamp.now(),
          'reportId': reportId, // ✅ ADD THIS
        });

        print('✅ Distributed to user: $userId'); // ✅ DEBUG
      }

      await batch.commit();
      print('🎯 Distribution completed successfully'); // ✅ DEBUG
    } catch (e) {
      print('❌ Distribution error: $e'); // ✅ DEBUG
    }
  } // ✅ REMOVED EXTRA batch.commit()

  // Get all reports for admin
  Stream<List<Report>> getReportsStream() {
    return _firestore
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Report.fromFirestore(doc))
        .toList());
  }

  // Get unread reports count for a user
  Stream<int> getUnreadReportsCount(String userId) {
    return _firestore
        .collection('user_reports')
        .doc(userId)
        .collection('unread_reports')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}