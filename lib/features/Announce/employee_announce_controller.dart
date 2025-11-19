import 'package:get/get.dart';
import 'package:hr_flow/features/admin_dashboard/screens/reports/report_model.dart';

import 'employee_announce_service.dart';

class EmployeeAnnounceController extends GetxController {
  final EmployeeAnnounceService _service = EmployeeAnnounceService();

  final RxInt unreadCount = 0.obs;
  final RxList<Report> announcements = <Report>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUnreadCount();
    _loadAnnouncements();
  }

  void _loadUnreadCount() {
    _service.getUnreadReportsCount().listen((count) {
      unreadCount.value = count;
    });
  }

  void _loadAnnouncements() {
    _service.getEmployeeReports().listen((reports) {
      announcements.assignAll(reports);
    });
  }

  Future<void> markAsRead(String reportId) async {
    await _service.markReportAsRead(reportId);
  }

  Future<void> markAllAsRead() async {
    await _service.markAllReportsAsRead();
  }

  void refreshData() {
    _loadUnreadCount();
    _loadAnnouncements();
  }
}