import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hr_flow/features/admin_dashboard/screens/reports/report_model.dart';

class EmployeeAnnounceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get unread reports count for current user - NULL SAFE VERSION
  Stream<int> getUnreadReportsCount() {
    final user = _auth.currentUser;
    if (user == null) {
      print('❌ User not authenticated, returning 0 count');
      return Stream.value(0); // ✅ RETURN EMPTY STREAM IF USER NULL
    }

    final userId = user.uid;
    print('🔄 Getting unread count for user: $userId');

    return _firestore
        .collection('user_reports')
        .doc(userId)
        .collection('unread_reports')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      print('📊 Unread count result: ${snapshot.docs.length}');
      return snapshot.docs.length;
    });
  }

  // Mark report as read - NULL SAFE VERSION
  Future<void> markReportAsRead(String reportId) async {
    final user = _auth.currentUser;
    if (user == null) {
      print('❌ User not authenticated, cannot mark as read');
      return;
    }

    final userId = user.uid;
    await _firestore
        .collection('user_reports')
        .doc(userId)
        .collection('unread_reports')
        .doc(reportId)
        .update({'isRead': true});
  }

  // Get all reports for employee
  Stream<List<Report>> getEmployeeReports() {
    return _firestore
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Report.fromFirestore(doc))
        .toList());
  }

  // Mark all reports as read - NULL SAFE VERSION
  Future<void> markAllReportsAsRead() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('❌ User not authenticated, cannot mark all as read');
      return;
    }

    final userId = user.uid;
    final unreadSnapshot = await _firestore
        .collection('user_reports')
        .doc(userId)
        .collection('unread_reports')
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in unreadSnapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}