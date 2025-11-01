import 'package:flutter/material.dart';
import 'package:hr_flow/features/chats/screens/main_chat_screen.dart';
import 'package:hr_flow/features/dashboard/screens/home_dashboard.dart';
import 'package:hr_flow/core/services/credential_store_service.dart';
import 'package:hr_flow/features/user/user_information/user_information.dart';

import '../profile/service/profile_update_service.dart';

class MainDashboard extends StatefulWidget {
  final String firstname;
  final String lastname;

  const MainDashboard({
    super.key,
    required this.firstname,
    required this.lastname,
  });

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeDashboard(fName: '', lName: ''),
      const Center(child: Text("History Screen")),
      MainChatScreen(),
      UserInformation(),
    ];
    _loadUserData();
    _updateExistingProfiles();
  }

  Future<void> _updateExistingProfiles() async {
    await ProfileUpdateService().updateExistingProfiles();
  }

  Future<void> _loadUserData() async {
    final firstName = await SecureStorageService.getFirstName();
    final lastName = await SecureStorageService.getLastName();

    if (mounted) {
      setState(() {
        _screens = [
          HomeDashboard(
            fName: firstName ?? widget.firstname,
            lName: lastName ?? widget.lastname,
          ),
          const Center(child: Text("History Screen")),
          MainChatScreen(),
          UserInformation(),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home, 'label': "Home", 'index': 0},
      {'icon': Icons.history, 'label': "History", 'index': 1},
      {'icon': Icons.message_rounded, 'label': "Message", 'index': 2},
      {'icon': Icons.account_circle_rounded, 'label': "Profile", 'index': 3},
    ];

    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(navItems[0], 0),
                  _buildNavItem(navItems[1], 1),
                  const SizedBox(width: 60),
                  _buildNavItem(navItems[2], 2),
                  _buildNavItem(navItems[3], 3),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(Map<String, dynamic> item, int index) {
    bool isSelected = _selectedIndex == item['index'];
    IconData icon = item['icon'];
    String label = item['label'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: 60,
        height: 70,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
