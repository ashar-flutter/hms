import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/chat_service.dart';

class ChatController {
  final _chatService = ChatService();

  Future<String> createChatRoom(String otherUserId) async {
    return await _chatService.getOrCreateChatRoom(otherUserId);
  }

  Future<void> sendMessage(String chatRoomId, String message) async {
    await _chatService.sendMessage(chatRoomId, message);
  }

  Stream<QuerySnapshot> getMessageStream(String chatRoomId) {
    return _chatService.getMessages(chatRoomId);
  }
}