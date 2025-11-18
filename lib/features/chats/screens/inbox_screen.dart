import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/chat_controller.dart';
import '../service/message_option_service.dart';

class InboxScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final String? otherUserImage;

  const InboxScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserImage,
  });

  @override
  State<InboxScreen> createState() => _InboxScreen();
}

class _InboxScreen extends State<InboxScreen> {
  final _messageController = TextEditingController();
  final _chatController = ChatController();
  final _messageOptionsService = MessageOptionsService();
  final _auth = FirebaseAuth.instance;
  String? _chatRoomId;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final chatRoomId = await _chatController.createChatRoom(widget.otherUserId);
    if (mounted) {
      setState(() {
        _chatRoomId = chatRoomId;
      });
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _chatRoomId == null) return;

    _messageController.clear();
    await _chatController.sendMessage(_chatRoomId!, message);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showMessageOptions(
      BuildContext context,
      String messageId,
      String currentReaction,
      ) {
    final emojis = ['😂', '😍', '😮', '😢', '😡', '👍', '❤️', '🔥'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.zero,
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: emojis.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (currentReaction == emojis[index]) {
                          _messageOptionsService.removeReaction(
                            _chatRoomId!,
                            messageId,
                          );
                        } else {
                          _messageOptionsService.addReaction(
                            _chatRoomId!,
                            messageId,
                            emojis[index],
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: currentReaction == emojis[index]
                              ? Colors.blue.withAlpha(25)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.withAlpha(76),
                          ),
                        ),
                        child: Text(
                          emojis[index],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colors.red.withAlpha(204),
                  ),
                  title: Text(
                    'Delete Message',
                    style: TextStyle(
                        fontFamily: "bold",
                        color: Colors.red.withAlpha(204)),
                  ),
                  onTap: () {
                    final currentUserId = _auth.currentUser!.uid;
                    _messageOptionsService.deleteMessageForMe(
                      _chatRoomId!,
                      messageId,
                      currentUserId,
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatMessageTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final time = timestamp.toDate();
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildMessageBubble(DocumentSnapshot messageDoc, bool isMe) {
    final message = messageDoc.data() as Map<String, dynamic>;
    final reaction = message['reaction'] ?? '';
    final currentUserId = _auth.currentUser!.uid;
    final deletedBy = List<String>.from(message['deletedBy'] ?? []);

    if (deletedBy.contains(currentUserId)) {
      return const SizedBox();
    }

    return GestureDetector(
      onLongPress: () => _showMessageOptions(context, messageDoc.id, reaction),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? const Color(0xFF007AFF)
                        : Colors.grey.withAlpha(25),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: isMe
                          ? const Radius.circular(18)
                          : const Radius.circular(6),
                      bottomRight: isMe
                          ? const Radius.circular(6)
                          : const Radius.circular(18),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['text'] ?? '',
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatMessageTime(message['timestamp']),
                        style: TextStyle(
                          color: isMe
                              ? Colors.white.withAlpha(178)
                              : Colors.grey.withAlpha(153),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                if (reaction.isNotEmpty)
                  Positioned(
                    bottom: -2,
                    right: isMe ? null : -4,
                    left: isMe ? -4 : null,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        reaction,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_chatRoomId == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: widget.otherUserImage != null
                    ? MemoryImage(base64Decode(widget.otherUserImage!))
                    : null,
                backgroundColor: Colors.grey.withAlpha(51),
                child: widget.otherUserImage == null
                    ? Icon(Icons.person, color: Colors.grey.withAlpha(153))
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                widget.otherUserName,
                style:  TextStyle(
                  fontFamily: "bold",
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          iconTheme: IconThemeData(color: Colors.black.withAlpha(178)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.otherUserImage != null
                  ? MemoryImage(base64Decode(widget.otherUserImage!))
                  : null,
              backgroundColor: Colors.grey.withAlpha(51),
              child: widget.otherUserImage == null
                  ? Icon(Icons.person, color: Colors.grey.withAlpha(153))
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              widget.otherUserName,
              style:  TextStyle(
                fontSize: 16,
                fontFamily: "bold",
                color: Colors.black,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black.withAlpha(178)),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatController.getMessageStream(_chatRoomId!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  final messages = snapshot.data!.docs;

                  if (_scrollController.hasClients && messages.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController.jumpTo(
                        _scrollController.position.maxScrollExtent,
                      );
                    });
                  }

                  return ListView.builder(
                    addAutomaticKeepAlives: true,
                    cacheExtent: 1000,
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageDoc = messages[index];
                      final message = messageDoc.data() as Map<String, dynamic>;
                      final isMe = message['senderId'] != widget.otherUserId;
                      return _buildMessageBubble(messageDoc, isMe);
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(25),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(
                          fontFamily: "poppins",
                          color: Colors.black87,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}