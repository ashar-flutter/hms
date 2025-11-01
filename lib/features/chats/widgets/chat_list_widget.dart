import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../service/chat_service.dart';
import '../service/unread_service.dart';
import '../screens/inbox_screen.dart';

class ChatListWithBadge extends StatefulWidget {
  const ChatListWithBadge({super.key});

  @override
  State<ChatListWithBadge> createState() => _ChatListWithBadgeState();
}

class _ChatListWithBadgeState extends State<ChatListWithBadge> {
  final _chatService = ChatService();
  final _unreadService = UnreadService();
  final _auth = FirebaseAuth.instance;

  String _getOtherUserId(List<dynamic> participants) {
    final currentUserId = _auth.currentUser!.uid;
    return participants.firstWhere(
          (id) => id != currentUserId,
          orElse: () => currentUserId,
        )
        as String;
  }

  Future<void> _openChat(
    Map<String, dynamic> chatData,
    Map<String, dynamic> userData,
  ) async {
    final currentUserId = _auth.currentUser!.uid;
    final chatRoomId = _getChatRoomId(currentUserId, userData['userId']);

    // Mark messages as read when opening chat
    await _unreadService.markMessagesAsRead(chatRoomId, currentUserId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InboxScreen(
          otherUserId: userData['userId'],
          otherUserName: '${userData['firstName']} ${userData['lastName']}',
          otherUserImage: userData['profileImage'],
        ),
      ),
    );
  }

  String _getChatRoomId(String user1, String user2) {
    return user1.compareTo(user2) < 0 ? '${user1}_$user2' : '${user2}_$user1';
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final messageTime = timestamp.toDate();

    if (now.difference(messageTime).inDays == 0) {
      return '${messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')}';
    } else if (now.difference(messageTime).inDays == 1) {
      return 'Yesterday';
    } else {
      return '${messageTime.day}/${messageTime.month}';
    }
  }

  // Badge widget for unread count
  Widget _buildBadge(int count) {
    if (count == 0) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Text(
        count > 9 ? '9+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getUserChats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No chats yet'));
        }

        final chats = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            final chatData = chat.data() as Map<String, dynamic>;
            final otherUserId = _getOtherUserId(chatData['participants']);
            final currentUserId = _auth.currentUser!.uid;
            final chatRoomId = _getChatRoomId(currentUserId, otherUserId);

            return StreamBuilder<int>(
              stream: _unreadService.getUnreadCountStream(chatRoomId),
              builder: (context, unreadSnapshot) {
                final unreadCount = unreadSnapshot.data ?? 0;

                return FutureBuilder<Map<String, dynamic>?>(
                  future: _getUserDetails(otherUserId),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return const SizedBox();
                    }

                    final userData = userSnapshot.data!;
                    final profileImage = userData['profileImage'];
                    final avatar = profileImage != null
                        ? MemoryImage(base64Decode(profileImage))
                        : null;

                    return ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: avatar,
                            backgroundColor: Colors.grey.shade300,
                            child: avatar == null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: _buildBadge(unreadCount),
                            ),
                        ],
                      ),
                      title: Text(
                        '${userData['firstName']} ${userData['lastName']}',
                        style: TextStyle(
                          fontWeight: unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        chatData['lastMessage'] ?? 'Start a conversation',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: unreadCount > 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatTime(chatData['lastMessageTime']),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          if (unreadCount > 0) const SizedBox(height: 4),
                          if (unreadCount > 0) _buildBadge(unreadCount),
                        ],
                      ),
                      onTap: () => _openChat(chatData, userData),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _getUserDetails(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    return doc.data();
  }
}
