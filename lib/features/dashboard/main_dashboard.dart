import 'package:flutter/material.dart';
import 'package:hr_flow/features/chats/screens/main_chat_screen.dart';
import 'package:hr_flow/features/dashboard/screens/home_dashboard.dart';
import 'package:hr_flow/core/services/credential_store_service.dart';
import 'package:hr_flow/features/user/user_information/user_information.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/services/unread_count_service.dart';
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
  late final List<Widget> _screens;
  final UnreadCountService _unreadCountService = UnreadCountService();

  static const List<Map<String, dynamic>> _navItems = [
    {'icon': Iconsax.home_1, 'label': "Home", 'index': 0},
    {'icon': Icons.history_toggle_off_outlined, 'label': "History", 'index': 1},
    {'icon': Iconsax.message, 'label': "Message", 'index': 2},
    {'icon': Iconsax.profile_circle, 'label': "Profile", 'index': 3},
  ];

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeDashboard(fName: '', lName: ''),
      const Center(child: Text("History Screen")),
      MainChatScreen(),
      UserInformation(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });

    _scheduleProfileUpdate();
  }

  void _scheduleProfileUpdate() {
    Future.microtask(() => ProfileUpdateService().updateExistingProfiles());
  }

  Future<void> _loadUserData() async {
    final firstName = await SecureStorageService.getFirstName();
    final lastName = await SecureStorageService.getLastName();

    if (mounted && (firstName != null || lastName != null)) {
      setState(() {
        _screens[0] = HomeDashboard(
          fName: firstName ?? widget.firstname,
          lName: lastName ?? widget.lastname,
        );
      });
    }
  }

  void _onNavItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: Offset(0, -5),
                ),
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(_navItems[0], 0),
                _buildNavItem(_navItems[1], 1),
                _buildNavItemWithBadge(_navItems[2], 2),
                _buildNavItem(_navItems[3], 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(Map<String, dynamic> item, int index) {
    final bool isSelected = _selectedIndex == item['index'];
    final IconData icon = item['icon'];
    final String label = item['label'];

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      behavior: HitTestBehavior.opaque,
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

  Widget _buildNavItemWithBadge(Map<String, dynamic> item, int index) {
    final bool isSelected = _selectedIndex == item['index'];
    final IconData icon = item['icon'];
    final String label = item['label'];

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 70,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
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
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: StreamBuilder<int>(
                stream: _unreadCountService.getTotalUnreadCountStream(),
                builder: (context, snapshot) {
                  final unreadCount = snapshot.data ?? 0;

                  if (unreadCount == 0) {
                    return const SizedBox();
                  }

                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}