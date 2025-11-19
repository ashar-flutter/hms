import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'create_report_screen.dart';
import 'report_controller.dart';

class ReportsListScreen extends StatelessWidget {
  ReportsListScreen({super.key});

  final ReportController _controller = Get.put(ReportController());

  Map<String, dynamic> _getReportTypeInfo(String type) {
    switch (type) {
      case 'meeting':
        return {
          'color': const Color(0xFF2563EB),
          'icon': Iconsax.calendar_2,
          'label': 'Meeting',
          'bgColor': Color(0xFFEFF6FF),
        };
      case 'holiday':
        return {
          'color': const Color(0xFF10B981),
          'icon': Iconsax.sun_1,
          'label': 'Holiday',
          'bgColor': Color(0xFFECFDF5),
        };
      case 'remote':
        return {
          'color': const Color(0xFFF59E0B),
          'icon': Iconsax.home_hashtag,
          'label': 'Remote',
          'bgColor': Color(0xFFFFFBEB),
        };
      case 'client_meeting':
        return {
          'color': const Color(0xFF8B5CF6),
          'icon': Iconsax.briefcase,
          'label': 'Client',
          'bgColor': Color(0xFFF5F3FF),
        };
      default:
        return {
          'color': Colors.grey,
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
          // Header with proper spacing
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
                  color: Colors.black.withOpacity(0.05),
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
                      'Reports',
                      style: TextStyle(
                        fontFamily: 'bold',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'LA Digital Agency',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2563EB).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Iconsax.add,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Get.to(() => const CreateReportScreen()),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              if (_controller.reports.isEmpty) {
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
                            color: Color(0xFF2563EB).withOpacity(0.1),
                          ),
                          child: Icon(
                            Iconsax.document,
                            size: 36,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Reports Yet',
                          style: TextStyle(
                            fontFamily: 'bold',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first report to get started',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _controller.reports.length,
                itemBuilder: (context, index) {
                  final report = _controller.reports[index];
                  final typeInfo = _getReportTypeInfo(report.type);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
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
                          color: Color(0xFF111827),
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
                              color: Color(0xFF6B7280),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          // FIXED ROW - No overflow
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
                                    color: typeInfo['color'].withOpacity(0.2),
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
                                DateFormat('MMM dd').format(report.createdAt),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: Color(0xFF9CA3AF),
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
