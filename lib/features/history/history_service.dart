import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> syncRequestToHistory(Map<String, dynamic> requestData) async {
    try {
      await _firestore
          .collection('leave_history')
          .doc(requestData['id'])
          .set(requestData);
      print('✅ History synced for request: ${requestData['id']}');
    } catch (e) {
      print('❌ Error syncing history: $e');
    }
  }

  static Future<void> updateHistoryStatus(String requestId, String status) async {
    try {
      await _firestore
          .collection('leave_history')
          .doc(requestId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ History status updated: $requestId -> $status');
    } catch (e) {
      print('❌ Error updating history status: $e');
    }
  }
}