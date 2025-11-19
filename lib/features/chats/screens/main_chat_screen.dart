import 'package:flutter/material.dart';
import '../widgets/chat_list_widget.dart';
import '../widgets/custom_searchbar.dart';
import '../widgets/custom_bar.dart';
import '../../../core/services/unread_count_service.dart';

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  final UnreadCountService _unreadCountService = UnreadCountService();

  @override
  void initState() {
    super.initState();
    _unreadCountService.markAllChatsAsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomBar(text: "Users"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const CustomSearchbarFixed(),
          Expanded(child: ChatListWithBadge()),
        ],
      ),
    );
  }
}