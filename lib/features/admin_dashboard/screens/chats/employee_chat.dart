import 'package:flutter/material.dart';
import 'package:hr_flow/features/admin_dashboard/screens/chats/widgets/employee_search_bar.dart';
import '../../../../core/services/unread_count_service.dart';
import '../../../chats/widgets/chat_list_widget.dart';
import '../../../chats/widgets/custom_bar.dart';

class EmployeeChat extends StatefulWidget {
  const EmployeeChat({super.key});

  @override
  State<EmployeeChat> createState() => _EmployeeChatState();
}

class _EmployeeChatState extends State<EmployeeChat> {
  final UnreadCountService _unreadCountService = UnreadCountService();
  bool _hasMarkedRead = false;

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  Future<void> _markMessagesAsRead() async {
    if (!_hasMarkedRead) {
      _hasMarkedRead = true;
      await _unreadCountService.markAllChatsAsRead();

      await Future.delayed(Duration(milliseconds: 500));
      await _unreadCountService.markAllChatsAsRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomBar(text: "Chats"),
      ),
      body: Column(
        children: [
          SizedBox(height: AppBar().preferredSize.height / 2),
          EmployeeSearchBar(),
          Expanded(child: ChatListWithBadge()),
        ],
      ),
    );
  }
}