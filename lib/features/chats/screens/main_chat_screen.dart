import 'package:flutter/material.dart';
import '../widgets/chat_list_widget.dart';
import '../widgets/custom_searchbar.dart';
import '../widgets/custom_bar.dart';

class MainChatScreen extends StatelessWidget {
  const MainChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomBar(
          text: "Users",
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const CustomSearchbarFixed(),
          Expanded(
            child: ChatListWithBadge(),
          ),
        ],
      ),
    );
  }
}