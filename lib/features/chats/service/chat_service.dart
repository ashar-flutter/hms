import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _getChatRoomId(String user1, String user2) {
    return user1.compareTo(user2) < 0
        ? '${user1}_$user2'
        : '${user2}_$user1';
  }

  Future<String> getOrCreateChatRoom(String otherUserId) async {
    final currentUserId = _auth.currentUser!.uid;
    final chatRoomId = _getChatRoomId(currentUserId, otherUserId);

    final chatRoomDoc = await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .get();

    if (!chatRoomDoc.exists) {
      await _firestore.collection('chats').doc(chatRoomId).set({
        'participants': [currentUserId, otherUserId],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }

  Future<void> sendMessage(String chatRoomId, String message) async {
    final currentUserId = _auth.currentUser!.uid;

    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    });

    await _firestore.collection('chats').doc(chatRoomId).update({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}