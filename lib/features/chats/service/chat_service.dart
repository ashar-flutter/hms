import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _getChatRoomId(String user1, String user2) {
    return user1.compareTo(user2) < 0 ? '${user1}_$user2' : '${user2}_$user1';
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
        'unreadCount_$currentUserId': 0,
        'unreadCount_$otherUserId': 0,
      });
    }

    return chatRoomId;
  }

  Future<void> sendMessage(String chatRoomId, String message) async {
    final currentUserId = _auth.currentUser!.uid;
    final otherUserId = _getOtherUserId(chatRoomId, currentUserId);

    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
      'read': false,
      'deletedBy': [],
    });

    // Update unread count for receiver
    await _firestore.collection('chats').doc(chatRoomId).update({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount_$otherUserId': FieldValue.increment(1),
    });
  }

  String _getOtherUserId(String chatRoomId, String currentUserId) {
    final parts = chatRoomId.split('_');
    return parts[0] == currentUserId ? parts[1] : parts[0];
  }

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserChats() {
    final userId = _auth.currentUser!.uid;
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }
}