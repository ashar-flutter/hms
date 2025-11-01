
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UnreadService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUnreadCount(String chatRoomId, String currentUserId) async {
    final messages = await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .where('read', isEqualTo: false)
        .get();

    await _firestore.collection('chats').doc(chatRoomId).update({
      'unreadCount_$currentUserId': messages.size,
    });
  }

  // Mark messages as read when chat is opened
  Future<void> markMessagesAsRead(String chatRoomId, String currentUserId) async {
    final messages = await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .where('read', isEqualTo: false)
        .get();

    for (final message in messages.docs) {
      await message.reference.update({'read': true});
    }

    await _firestore.collection('chats').doc(chatRoomId).update({
      'unreadCount_$currentUserId': 0,
    });
  }


  Stream<int> getUnreadCountStream(String chatRoomId) {
    final currentUserId = _auth.currentUser!.uid;
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      return data?['unreadCount_$currentUserId'] ?? 0;
    });
  }
}