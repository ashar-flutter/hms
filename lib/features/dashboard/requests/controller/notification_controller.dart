import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String _collectionName = 'notifications';
  RxInt unreadCount = 0.obs;
  RxList<Map<String, dynamic>> notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    print('🔔 NotificationController initialized');
    _loadNotifications();
  }

  void _loadNotifications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      notifications.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      unreadCount.value = notifications.where((n) => n['isRead'] == false).length;
      print('🔔 Notifications loaded: ${notifications.length} (Unread: ${unreadCount.value})');
    });
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection(_collectionName).doc(notificationId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
      print('🔔 Notification marked as read: $notificationId');
    } catch (e) {
      print('❌ Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final unreadNotifications = notifications.where((n) => n['isRead'] == false).toList();
      for (final notification in unreadNotifications) {
        await markAsRead(notification['id']);
      }
      print('🔔 All notifications marked as read');
    } catch (e) {
      print('❌ Error marking all notifications as read: $e');
    }
  }

  Future<bool> checkNotificationsExist() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;

    final snapshot = await _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}