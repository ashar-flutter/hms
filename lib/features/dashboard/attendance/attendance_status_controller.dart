import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hr_flow/features/dashboard/attendance/service/secure_attendance_service.dart';

class SecureAttendanceController extends GetxController {
  final SecureAttendanceService _service = SecureAttendanceService();

  var checkInTime = Rxn<DateTime>();
  var checkOutTime = Rxn<DateTime>();
  var workDuration = 0.obs;
  var isCheckedIn = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final inTime = await _service.getCheckInTime();
      final outTime = await _service.getCheckOutTime();
      final checkedIn = await _service.isCheckedIn();

      checkInTime.value = inTime;
      checkOutTime.value = outTime;
      isCheckedIn.value = checkedIn;

      if (inTime != null && checkedIn) {
        // User checked in hai aur abhi check-out nahi kiya
        workDuration.value = DateTime.now().difference(inTime).inSeconds;
        _startTimer();
      } else if (inTime != null && outTime != null) {
        // Check-out ho chuka hai
        workDuration.value = outTime.difference(inTime).inSeconds;
      }
    } catch (e) {
      print('Error loading attendance status: $e');
    }
  }

  Future<void> checkIn() async {
    try {
      final now = DateTime.now();
      checkInTime.value = now;
      checkOutTime.value = null;
      workDuration.value = 0;
      isCheckedIn.value = true;

      await _service.saveCheckInTime(now);
      _startTimer();
      update();
    } catch (e) {
      print('Error during check-in: $e');
    }
  }

  Future<void> checkOut() async {
    try {
      if (checkInTime.value != null && isCheckedIn.value) {
        final now = DateTime.now();
        checkOutTime.value = now;
        workDuration.value = now.difference(checkInTime.value!).inSeconds;
        isCheckedIn.value = false;

        await _service.saveCheckOutTime(now);
        _stopTimer();
        update();
      }
    } catch (e) {
      print('Error during check-out: $e');
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (checkInTime.value != null && isCheckedIn.value) {
        workDuration.value = DateTime.now().difference(checkInTime.value!).inSeconds;
        update();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String formatDuration(int totalSeconds) {
    final h = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }


  String formatDateTime(DateTime? dt) {
    if (dt == null) return "--:--:--";


    final formatter = DateFormat('hh:mm:ss a');
    return formatter.format(dt);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}