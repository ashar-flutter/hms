import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/chat_list_service.dart';

class ChatListController {
  final _chatListService = ChatListService();

  Stream<QuerySnapshot> getChatsStream() {
    return _chatListService.getUserChats();
  }

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    return await _chatListService.getUserDetails(userId);
  }
}
