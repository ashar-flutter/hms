import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UnreadCountService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<int> getTotalUnreadCountStream() {
    final currentUserId = _auth.currentUser!.uid;

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .asyncMap((snapshot) async {
      int totalUnread = 0;

      for (final chatDoc in snapshot.docs) {
        final chatRoomId = chatDoc.id;

        final messagesSnapshot = await _firestore
            .collection('chats')
            .doc(chatRoomId)
            .collection('messages')
            .where('senderId', isNotEqualTo: currentUserId)
            .get();

        final unreadMessages = messagesSnapshot.docs.where((messageDoc) {
          final messageData = messageDoc.data();
          final readBy = List<String>.from(messageData['readBy'] ?? []);
          return !readBy.contains(currentUserId);
        }).length;

        totalUnread += unreadMessages;
      }

      return totalUnread;
    });
  }

  Future<void> markAllChatsAsRead() async {
    final currentUserId = _auth.currentUser!.uid;

    final chatsSnapshot = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .get();

    for (final chatDoc in chatsSnapshot.docs) {
      final chatRoomId = chatDoc.id;

      final messagesSnapshot = await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .where('senderId', isNotEqualTo: currentUserId)
          .get();

      final batch = _firestore.batch();

      for (final messageDoc in messagesSnapshot.docs) {
        final messageData = messageDoc.data();
        final readBy = List<String>.from(messageData['readBy'] ?? []);

        if (!readBy.contains(currentUserId)) {
          final messageRef = _firestore
              .collection('chats')
              .doc(chatRoomId)
              .collection('messages')
              .doc(messageDoc.id);

          readBy.add(currentUserId);
          batch.update(messageRef, {'readBy': readBy});
        }
      }

      if (messagesSnapshot.docs.isNotEmpty) {
        await batch.commit();
      }
    }
  }
}