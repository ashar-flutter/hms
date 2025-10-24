import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/chat_list_controller.dart';
import '../screens/inbox_screen.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({super.key});

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  final _chatListController = ChatListController();
  final _auth = FirebaseAuth.instance;

  String _getOtherUserId(List<dynamic> participants) {
    final currentUserId = _auth.currentUser!.uid;
    return participants.firstWhere(
          (id) => id != currentUserId,
      orElse: () => currentUserId,
    ) as String;
  }

  void _openChat(Map<String, dynamic> chatData, Map<String, dynamic> userData) {
    final otherUserId = _getOtherUserId(chatData['participants']);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InboxScreen(
          otherUserId: otherUserId,
          otherUserName: '${userData['firstName']} ${userData['lastName']}',
          otherUserImage: userData['profileImage'],
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatListController.getChatsStream(),
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

            return FutureBuilder<Map<String, dynamic>?>(
              future: _chatListController.getUserDetails(otherUserId),
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
                  leading: CircleAvatar(
                    backgroundImage: avatar,
                    backgroundColor: Colors.grey.shade300,
                    child: avatar == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  title: Text(
                    '${userData['firstName']} ${userData['lastName']}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    chatData['lastMessage'] ?? 'Start a conversation',
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    _formatTime(chatData['lastMessageTime']),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => _openChat(chatData, userData),
                );
              },
            );
          },
        );
      },
    );
  }
}