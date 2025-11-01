import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageOptionsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> deleteMessageForMe(String chatRoomId, String messageId, String currentUserId) async {
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({
      'deletedBy': FieldValue.arrayUnion([currentUserId]),
    });

    await _updateLastMessage(chatRoomId, currentUserId);
  }

  Future<void> _updateLastMessage(String chatRoomId, String currentUserId) async {
    try {
      final chatDoc = await _firestore.collection('chats').doc(chatRoomId).get();
      final chatData = chatDoc.data();
      final currentLastMessage = chatData?['lastMessage'] ?? '';

      if (currentLastMessage.isEmpty) return;

      // Sab messages lao aur client-side filter karo
      final allMessages = await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      // Filter undeleted messages
      final undeletedMessages = allMessages.docs.where((doc) {
        final message = doc.data();
        final deletedBy = List<String>.from(message['deletedBy'] ?? []);
        return !deletedBy.contains(currentUserId);
      }).toList();

      if (undeletedMessages.isNotEmpty) {
        final lastUndeletedMessage = undeletedMessages.first.data();
        final newLastMessage = lastUndeletedMessage['text'] ?? '';

        if (newLastMessage != currentLastMessage) {
          await _firestore.collection('chats').doc(chatRoomId).update({
            'lastMessage': newLastMessage,
            'lastMessageTime': lastUndeletedMessage['timestamp'],
          });
        }
      } else {
        await _firestore.collection('chats').doc(chatRoomId).update({
          'lastMessage': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating last message: $e');
    }
  }

  Future<void> addReaction(String chatRoomId, String messageId, String emoji) async {
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({
      'reaction': emoji,
    });
  }

  Future<void> removeReaction(String chatRoomId, String messageId) async {
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({
      'reaction': FieldValue.delete(),
    });
  }
}