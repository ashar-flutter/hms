// lib/features/reports/controller/report_controller.dart
import 'package:get/get.dart';
import 'package:hr_flow/features/admin_dashboard/screens/reports/report_model.dart';
import 'package:hr_flow/features/admin_dashboard/screens/reports/report_service.dart';

class ReportController extends GetxController {
  final ReportService _reportService = ReportService();
  final RxList<Report> reports = <Report>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  void loadReports() {
    _reportService.getReportsStream().listen((reportsList) {
      reports.assignAll(reportsList);
    });
  }

  Future<bool> createNewReport({
    required String title,
    required String type,
    required String message,
  }) async {
    try {
      isLoading.value = true;
      await _reportService.createReport(
        title: title,
        type: type,
        message: message,
      );
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }
}
