import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaveBalanceService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? 'default_user';
  }

  static Future<Map<String, dynamic>> getUserBalance() async {
    try {
      final doc = await _firestore
          .collection('leave_balance')
          .doc(getCurrentUserId())
          .get();

      if (doc.exists) return doc.data()!;

      await initializeUserBalance();
      return {
        'annualBalance': 36,
        'usedLeaves': 0,
        'monthlyUsed': 0,
        'weeklyUsed': 0
      };
    } catch (e) {
      return {
        'annualBalance': 36,
        'usedLeaves': 0,
        'monthlyUsed': 0,
        'weeklyUsed': 0
      };
    }
  }

  static Future<void> initializeUserBalance() async {
    await _firestore
        .collection('leave_balance')
        .doc(getCurrentUserId())
        .set({
      'annualBalance': 36,
      'usedLeaves': 0,
      'monthlyUsed': 0,
      'weeklyUsed': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateLeaveBalance(int leaveCount) async {
    await _firestore
        .collection('leave_balance')
        .doc(getCurrentUserId())
        .update({
      'annualBalance': FieldValue.increment(-leaveCount),
      'usedLeaves': FieldValue.increment(leaveCount),
      'monthlyUsed': FieldValue.increment(leaveCount),
      'weeklyUsed': FieldValue.increment(leaveCount),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<DocumentSnapshot> getBalanceStream() {
    return _firestore
        .collection('leave_balance')
        .doc(getCurrentUserId())
        .snapshots();
  }
}