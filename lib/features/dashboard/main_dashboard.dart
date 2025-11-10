import 'package:flutter/material.dart';
import 'package:hr_flow/features/chats/screens/main_chat_screen.dart';
import 'package:hr_flow/features/dashboard/screens/home_dashboard.dart';
import 'package:hr_flow/core/services/credential_store_service.dart';
import 'package:hr_flow/features/user/user_information/user_information.dart';
import 'package:iconsax/iconsax.dart';

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
     UserInformation()
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
          UserInformation()
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {'icon': Iconsax.home_1, 'label': "Home", 'index': 0},
      {
        'icon': Icons.history_toggle_off_outlined,
        'label': "History",
        'index': 1,
      },
      {'icon': Iconsax.message, 'label': "Message", 'index': 2},
      {'icon': Iconsax.profile_circle, 'label': "Profile", 'index': 3},
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
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 25,
                    spreadRadius: 2,
                    offset: const Offset(0, -5),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(navItems[0], 0),
                  _buildNavItem(navItems[1], 1),
                  _buildNavItem(navItems[2], 2),
                  _buildNavItem(navItems[3], 3),
                ],
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
