import 'package:flutter/material.dart';
import 'package:hr_flow/features/admin_dashboard/screens/chats/widgets/employee_search_bar.dart';

import '../../../chats/widgets/chat_list_widget.dart';
import '../../../chats/widgets/custom_bar.dart';

class EmployeeChat extends StatelessWidget {
  const EmployeeChat({super.key});

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
