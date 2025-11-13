import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
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
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> addRequest(RequestModel request) async {
    try {
      final userProfile = await getUserProfileData(request.userId);

      String? safeFileData = request.fileData;
      if (safeFileData != null && safeFileData.length > 300000) {
        safeFileData = null;
      }

      Map<String, dynamic> simpleData = {
        'id': request.id,
        'userId': request.userId,
        'userName': request.userName,
        'userEmail': userProfile?['email'] ?? getCurrentUserEmail(),
        'userProfileImage': userProfile?['profileImage'],
        'userRole': userProfile?['role'] ?? 'employee',
        'userFirstName': userProfile?['firstName'] ?? '',
        'userLastName': userProfile?['lastName'] ?? '',
        'category': request.category,
        'type': request.type,
        'reason': request.reason,
        'description': request.description,
        'filePath': request.filePath,
        'fileName': request.fileName,
        'fileData': safeFileData,
        'fileUrl': request.fileUrl,
        'fromDate': request.fromDate?.millisecondsSinceEpoch,
        'toDate': request.toDate?.millisecondsSinceEpoch,
        'status': request.status,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };

      final jsonString = jsonEncode(simpleData);
      if (jsonString.length > 1000000) {
        simpleData['fileData'] = null;
        simpleData['fileName'] = null;
      }

      final firestoreData = {
        ...simpleData,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection(_collectionName)
          .doc(request.id)
          .set(firestoreData);

    } catch (e) {
      if (e.toString().contains('exceeds the maximum allowed size')) {
        await _saveWithoutFileData(request);
      }
    }
  }

  Future<void> _saveWithoutFileData(RequestModel request) async {
    try {
      final userProfile = await getUserProfileData(request.userId);

      final requestData = {
        'id': request.id,
        'userId': request.userId,
        'userName': request.userName,
        'userEmail': userProfile?['email'] ?? getCurrentUserEmail(),
        'userProfileImage': userProfile?['profileImage'],
        'userRole': userProfile?['role'] ?? 'employee',
        'userFirstName': userProfile?['firstName'] ?? '',
        'userLastName': userProfile?['lastName'] ?? '',
        'category': request.category,
        'type': request.type,
        'reason': request.reason,
        'description': request.description,
        'filePath': null,
        'fileName': null,
        'fileData': null,
        'fileUrl': request.fileUrl,
        'fromDate': request.fromDate?.millisecondsSinceEpoch,
        'toDate': request.toDate?.millisecondsSinceEpoch,
        'status': request.status,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection(_collectionName)
          .doc(request.id)
          .set(requestData);

    } catch (e) {
    //
    }
  }

  List<RequestModel> getAllRequests() {
    return requests;
  }

  List<RequestModel> getCurrentUserRequests() {
    final userId = getCurrentUserId();
    final userRequests = requests
        .where((request) => request.userId == userId)
        .toList();
    return userRequests;
  }

  Future<void> approveRequest(String requestId) async {
    try {
      final request = requests.firstWhere((r) => r.id == requestId);

      await _firestore.collection(_collectionName).doc(requestId).update({
        'status': 'approved',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _createNotification(
        userId: request.userId,
        title: 'Leave Request Approved ✅',
        message: 'Your "${request.category}" has been approved by admin',
        type: 'approval',
        requestId: requestId,
      );
    } catch (e) {
    //
    }
  }

  Future<void> rejectRequest(String requestId) async {
    try {
      final request = requests.firstWhere((r) => r.id == requestId);

      await _firestore.collection(_collectionName).doc(requestId).update({
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _createNotification(
        userId: request.userId,
        title: 'Leave Request Rejected ❌',
        message: 'Your "${request.category}" has been rejected by admin',
        type: 'rejection',
        requestId: requestId,
      );
    } catch (e) {
    //
    }
  }

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

      await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .set(notificationData);
    } catch (e) {
    //
    }
  }
}