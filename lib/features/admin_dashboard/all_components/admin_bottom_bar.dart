import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/services/unread_count_service.dart';

class AdminBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback? onCenterTap;
  final UnreadCountService unreadCountService = UnreadCountService();

  AdminBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.onCenterTap,
  });

  static const List<Map<String, dynamic>> _navItems = [
    {'icon': Iconsax.home_1, 'label': "Dashboard"},
    {'icon': Iconsax.message, 'label': "Chats"},
    {'icon': Iconsax.activity, 'label': "Reports"},
    {'icon': Iconsax.profile_circle, 'label': "Profile"},
  ];

  static const List<BoxShadow> _boxShadows = [
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
  ];

  @override
  Widget build(BuildContext context) {
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
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              boxShadow: _boxShadows,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(_navItems[0], 0),
                _buildNavItemWithBadge(_navItems[1], 1),
                _buildNavItem(_navItems[2], 2),
                _buildNavItem(_navItems[3], 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(Map<String, dynamic> item, int index) {
    final bool isSelected = selectedIndex == index;
    final IconData icon = item['icon'];
    final String label = item['label'];

    return GestureDetector(
      onTap: () => onItemSelected(index),
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
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF9CA3AF),
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

  Widget _buildNavItemWithBadge(Map<String, dynamic> item, int index) {
    final bool isSelected = selectedIndex == index;
    final IconData icon = item['icon'];
    final String label = item['label'];

    return GestureDetector(
      onTap: () async {
        // ✅ YEH LINE ADD KARO - Message icon click pe mark as read
        if (index == 1) {
          await unreadCountService.markAllChatsAsRead();
        }
        onItemSelected(index);
      },
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
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF9CA3AF),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 6,
              right: 6,
              child: StreamBuilder<int>(
                stream: unreadCountService.getTotalUnreadCountStream(),
                builder: (context, snapshot) {
                  final unreadCount = snapshot.data ?? 0;

                  if (unreadCount == 0) {
                    return const SizedBox();
                  }

                  return Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 7,
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