import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'employee_announce_controller.dart';

class AnnounceCardWidget extends StatelessWidget {
  final VoidCallback onTap;

  const AnnounceCardWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeAnnounceController>();

    return Obx(() {
      print('🎯 Current unread count: ${controller.unreadCount.value}');

      return Container(
        width: 158,
        height: 140,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main Card
            GestureDetector(
              onTap: () {
                if (controller.unreadCount.value > 0) {
                  controller.markAllAsRead();
                }
                onTap();
              },
              child: Container(
                width: 158,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon Container
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.notification_bing,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Announce..',
                      style: TextStyle(
                        fontFamily: 'bold',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Company Updates',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Badge Count - COMPLETELY VISIBLE POSITION
            if (controller.unreadCount.value > 0)
              Positioned(
                top: -5,   // ✅ ADJUSTED
                right: -5, // ✅ ADJUSTED
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                  child: Text(
                    controller.unreadCount.value > 9 ?
                    '9+' : controller.unreadCount.value.toString(),
                    style: const TextStyle(
                      fontFamily: 'bold',
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.white,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}