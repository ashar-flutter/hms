// lib/features/dashboard/announce/screens/announce_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'employee_announce_controller.dart';

class AnnounceListScreen extends StatelessWidget {
  AnnounceListScreen({super.key});

  final EmployeeAnnounceController _controller =
      Get.find<EmployeeAnnounceController>();

  Map<String, dynamic> _getReportTypeInfo(String type) {
    switch (type) {
      case 'meeting':
        return {
          'color': Color(0xFF2563EB),
          'icon': Iconsax.calendar_2,
          'label': 'Meeting',
          'bgColor': Color(0xFFEFF6FF),
        };
      case 'holiday':
        return {
          'color': Color(0xFF10B981),
          'icon': Iconsax.sun_1,
          'label': 'Holiday',
          'bgColor': Color(0xFFECFDF5),
        };
      case 'remote':
        return {
          'color': Color(0xFFF59E0B),
          'icon': Iconsax.home_hashtag,
          'label': 'Remote',
          'bgColor': Color(0xFFFFFBEB),
        };
      case 'client_meeting':
        return {
          'color': Color(0xFF8B5CF6),
          'icon': Iconsax.briefcase,
          'label': 'Client',
          'bgColor': Color(0xFFF5F3FF),
        };
      default:
        return {
          'color': Color(0xFF6B7280),
          'icon': Iconsax.document,
          'label': 'Report',
          'bgColor': Color(0xFFF3F4F6),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05), // ✅ FIXED
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Announcements',
                      style: TextStyle(
                        fontFamily: 'bold',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'LA Digital Agency',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => _controller.unreadCount.value > 0
                      ? GestureDetector(
                          onTap: _controller.markAllAsRead,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Mark All Read',
                              style: TextStyle(
                                fontFamily: 'bold',
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              if (_controller.announcements.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF2563EB,
                            ).withValues(alpha: 0.1), // ✅ FIXED
                          ),
                          child: Icon(
                            Iconsax.notification,
                            size: 36,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Announcements',
                          style: TextStyle(
                            fontFamily: 'bold',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You\'re all caught up!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _controller.announcements.length,
                itemBuilder: (context, index) {
                  final report = _controller.announcements[index];
                  final typeInfo = _getReportTypeInfo(report.type);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.05,
                          ), // ✅ FIXED
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.1), // ✅ FIXED
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: typeInfo['bgColor'],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          typeInfo['icon'],
                          color: typeInfo['color'],
                          size: 22,
                        ),
                      ),
                      title: Text(
                        report.title,
                        style: TextStyle(
                          fontFamily: 'bold',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: const Color(0xFF111827),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            report.message,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: const Color(0xFF6B7280),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: typeInfo['bgColor'],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: (typeInfo['color'] as Color)
                                        .withValues(alpha: 0.2), // ✅ FIXED
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  typeInfo['label'],
                                  style: TextStyle(
                                    fontFamily: 'bold',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: typeInfo['color'],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                DateFormat(
                                  'MMM dd, hh:mm a',
                                ).format(report.createdAt),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
