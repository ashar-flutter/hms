import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AdminBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback? onCenterTap;

  const AdminBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {'icon': Iconsax.home_1, 'label': "Dashboard"},
      {'icon': Iconsax.message, 'label': "Chats"},
      {'icon': Iconsax.activity, 'label': "Reports"},
      {'icon': Iconsax.profile_circle, 'label': "Profile"},
    ];

    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 19,
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
    );
  }

  Widget _buildNavItem(Map<String, dynamic> item, int index) {
    bool isSelected = selectedIndex == index;
    IconData icon = item['icon'];
    String label = item['label'];

    return GestureDetector(
      onTap: () => onItemSelected(index),
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
              color:
              isSelected ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
