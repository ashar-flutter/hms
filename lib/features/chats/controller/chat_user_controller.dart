import '../service/chat_user_service.dart';

class ChatUserController {
  final _service = ChatUserService();

  Future<List<Map<String, dynamic>>> getUsersBySearch(String query) async {
    return await _service.searchUsers(query);
  }
}