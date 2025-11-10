import 'package:get/get.dart';
import '../services/admin_attendance_service.dart';

class AdminAttendanceController extends GetxController {
  final AdminAttendanceService _attendanceService = AdminAttendanceService();

  var activeEmployeesCount = 0.obs;
  var activeEmployees = <Map<String, dynamic>>[].obs;
  var todayAllEmployees = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _startRealtimeListener();
  }

  void _startRealtimeListener() {
    _attendanceService.getLiveAttendanceStream().listen((snapshot) {
      _updateActiveEmployees();
    });
  }

  Future<void> refreshData() async {
    await _updateActiveEmployees();
  }

  Future<void> _updateActiveEmployees() async {
    final currentlyActive = await _attendanceService.getCurrentlyActiveUsers();
    final allTodayUsers = await _attendanceService.getTodayActiveUsers();

    activeEmployeesCount.value = currentlyActive.length;
    activeEmployees.value = allTodayUsers;
    todayAllEmployees.value = allTodayUsers;
  }
}