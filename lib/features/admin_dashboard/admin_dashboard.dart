import 'package:flutter/material.dart';
import 'package:hr_flow/features/admin_dashboard/screens/chats/employee_chat.dart';
import 'package:hr_flow/features/admin_dashboard/screens/main_admin_dashboard.dart';

import 'all_components/admin_bottom_bar.dart';

class AdminDashboard extends StatefulWidget {
  final String naame;
  final String lNaame;
  const AdminDashboard({super.key,
  required this.naame,
    required this.lNaame
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MainAdminDashboard(
        name: widget.naame,
        lName: widget.lNaame,
      ),
      EmployeeChat(),
      const Center(child: Text("Reports Section")),
      const Center(child: Text("Admin Profile")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: AdminBottomBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
