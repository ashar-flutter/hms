import 'package:flutter/material.dart';
import 'package:hr_flow/features/chats/screens/main_chat_screen.dart';
import 'package:hr_flow/features/dashboard/screens/home_dashboard.dart';
import 'package:hr_flow/core/services/credential_store_service.dart';

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
      const Center(child: Text("Profile Screen")),
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
          const Center(child: Text("Profile Screen")),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 90,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F2D),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withAlpha(100),
              blurRadius: 25,
              spreadRadius: 3,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withAlpha(120),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
          border: Border.all(color: const Color(0xFF404A6C), width: 1.5),
        ),
        child: Row(
          children: [
            _buildNavItem(Icons.home_rounded, "Home", 0),
            _buildNavItem(Icons.assignment_rounded, "History", 1),
            _buildNavItem(Icons.forum_rounded, "Chats", 2),
            _buildNavItem(Icons.account_circle_rounded, "Profile", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: SizedBox(
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 50,
                height: 34,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(
                          color: Colors.white.withAlpha(40),
                          width: 1.5,
                        )
                      : null,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected ? Colors.white : const Color(0xFFD1D5DB),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF60A5FA)
                      : const Color(0xFF9CA3AF),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
