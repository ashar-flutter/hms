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

        final lastMessageSnapshot = await _firestore
            .collection('chats')
            .doc(chatRoomId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (lastMessageSnapshot.docs.isNotEmpty) {
          final lastMessage = lastMessageSnapshot.docs.first.data();
          final senderId = lastMessage['senderId'];
          final readBy = List<String>.from(lastMessage['readBy'] ?? []);

          if (senderId != currentUserId && !readBy.contains(currentUserId)) {
            totalUnread += 1;
          }
        }
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

    final batch = _firestore.batch();

    for (final chatDoc in chatsSnapshot.docs) {
      final chatRoomId = chatDoc.id;

      // Pehle sirf senderId filter karo
      final messagesSnapshot = await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .where('senderId', isNotEqualTo: currentUserId)
          .get();

      for (final messageDoc in messagesSnapshot.docs) {
        final messageData = messageDoc.data();
        final readBy = List<String>.from(messageData['readBy'] ?? []);

        // Client side pe check karo agar read nahi hai
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
    }

    if (chatsSnapshot.docs.isNotEmpty) {
      await batch.commit();
    }
  }
}