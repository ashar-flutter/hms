import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'attendance_helper.dart';

class AttendanceController extends ChangeNotifier {
  bool _isCheckedIn = false;
  DateTime? _checkInTime;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  String? _checkInDate;
  String? _checkInTimeString;

  bool get isCheckedIn => _isCheckedIn;
  Duration get elapsed => _elapsed;
  String? get checkInDate => _checkInDate;
  String? get checkInTimeString => _checkInTimeString;

  Future<void> restoreState() async {
    _isCheckedIn = await AttendanceHelper.isCheckedIn();
    if (_isCheckedIn) {
      _checkInTime = await AttendanceHelper.getCheckInTime();
      _checkInDate = await AttendanceHelper.getCheckInDate();
      _checkInTimeString = await AttendanceHelper.getCheckInTimeString();

      if (_checkInTime != null) {
        _startTimer();
      }
    } else {
      _checkInDate = null;
      _checkInTimeString = null;
    }
    notifyListeners();
  }

  Future<void> checkIn() async {
    _checkInTime = DateTime.now();
    _isCheckedIn = true;
    _checkInDate = DateFormat('EEE, MMM d, yyyy').format(_checkInTime!);
    _checkInTimeString = DateFormat('hh:mm:ss a').format(_checkInTime!);

    await AttendanceHelper.saveCheckInTime(_checkInTime!);
    _startTimer();
    notifyListeners();
  }

  Future<void> checkOut() async {
    _isCheckedIn = false;
    _checkInTime = null;
    _checkInDate = null;
    _checkInTimeString = null;
    _elapsed = Duration.zero;

    await AttendanceHelper.saveCheckOut();
    _timer?.cancel();
    notifyListeners();
  }

  // Break related methods
  Future<void> saveBreakState(bool isOnBreak, Duration breakDuration) async {
    await AttendanceHelper.saveBreakState(isOnBreak, breakDuration);
  }

  Future<bool> getBreakStatus() async {
    return await AttendanceHelper.getBreakStatus();
  }

  Future<Duration> getBreakDuration() async {
    return await AttendanceHelper.getBreakDuration();
  }

  _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_checkInTime != null) {
        _elapsed = DateTime.now().difference(_checkInTime!);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}