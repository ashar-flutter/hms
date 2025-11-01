import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/request_model.dart';

class RequestStatusController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String _collectionName = 'leave_requests';
  final String _usersCollection = 'users';
  final String _notificationsCollection = 'notifications';
  RxList<RequestModel> requests = <RequestModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    print('🎯 Firebase RequestStatusController CREATED: ${this.hashCode}');
    _loadRequestsFromFirebase();
  }

  void _loadRequestsFromFirebase() {
    _firestore.collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      requests.value = snapshot.docs.map((doc) {
        return RequestModel.fromJson(doc.data());
      }).toList();
      print('📂 Loaded ${requests.length} requests from Firebase');
    });
  }

  String getCurrentUserId() {
    return _auth.currentUser?.uid ?? 'unknown_user';
  }

  String getCurrentUserName() {
    return _auth.currentUser?.displayName ?? 'Current User';
  }

  String getCurrentUserEmail() {
    return _auth.currentUser?.email ?? 'unknown@email.com';
  }

  Future<Map<String, dynamic>?> getUserProfileData(String userId) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      return null;
    }
  }

  Future<void> addRequest(RequestModel request) async {
    try {
      final userProfile = await getUserProfileData(request.userId);

      final requestData = {
        ...request.toJson(),
        'userEmail': userProfile?['email'] ?? getCurrentUserEmail(),
        'userProfileImage': userProfile?['profileImage'],
        'userRole': userProfile?['role'] ?? 'employee',
        'userFirstName': userProfile?['firstName'] ?? '',
        'userLastName': userProfile?['lastName'] ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection(_collectionName).doc(request.id).set(requestData);
      print('✅ Request saved to Firebase with profile data: ${request.id}');
    } catch (e) {
      print('❌ Error saving to Firebase: $e');
    }
  }

  List<RequestModel> getAllRequests() {
    print('👑 ADMIN VIEW - Total requests: ${requests.length}');
    return requests;
  }

  List<RequestModel> getCurrentUserRequests() {
    final userId = getCurrentUserId();
    final userRequests = requests.where((request) => request.userId == userId).toList();
    print('📱 USER VIEW - User $userId requests: ${userRequests.length}');
    return userRequests;
  }

  // ✅ APPROVE REQUEST WITH NOTIFICATION
  Future<void> approveRequest(String requestId) async {
    try {
      final request = requests.firstWhere((r) => r.id == requestId);

      // ✅ REQUEST UPDATE KARO
      await _firestore.collection(_collectionName).doc(requestId).update({
        'status': 'approved',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // ✅ NOTIFICATION CREATE KARO
      await _createNotification(
        userId: request.userId,
        title: 'Leave Request Approved ✅',
        message: 'Your "${request.category}" has been approved by admin',
        type: 'approval',
        requestId: requestId,
      );

      print('✅ Request APPROVED and notification sent to user: ${request.userId}');
    } catch (e) {
      print('❌ Error approving request: $e');
    }
  }

  // ✅ REJECT REQUEST WITH NOTIFICATION
  Future<void> rejectRequest(String requestId) async {
    try {
      final request = requests.firstWhere((r) => r.id == requestId);

      await _firestore.collection(_collectionName).doc(requestId).update({
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // ✅ NOTIFICATION CREATE KARO
      await _createNotification(
        userId: request.userId,
        title: 'Leave Request Rejected ❌',
        message: 'Your "${request.category}" has been rejected by admin',
        type: 'rejection',
        requestId: requestId,
      );

      print('❌ Request REJECTED and notification sent to user: ${request.userId}');
    } catch (e) {
      print('❌ Error rejecting request: $e');
    }
  }

  // ✅ NOTIFICATION CREATE KARO
  Future<void> _createNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    required String requestId,
  }) async {
    try {
      final notificationId = DateTime.now().millisecondsSinceEpoch.toString();

      final notificationData = {
        'id': notificationId,
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'requestId': requestId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection(_notificationsCollection).doc(notificationId).set(notificationData);

      print('🔔 Notification created for user: $userId - $title');
    } catch (e) {
      print('❌ Error creating notification: $e');
    }
  }
}