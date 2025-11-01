import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AttendanceController extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

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
    final isChecked = await _storage.read(key: 'isCheckedIn');
    final checkInTimeStr = await _storage.read(key: 'checkInTime');

    _isCheckedIn = isChecked == 'true';

    if (_isCheckedIn && checkInTimeStr != null) {
      _checkInTime = DateTime.parse(checkInTimeStr);
      _checkInDate = DateFormat('EEE, MMM d, yyyy').format(_checkInTime!);
      _checkInTimeString = DateFormat('hh:mm:ss a').format(_checkInTime!);
      _elapsed = DateTime.now().difference(_checkInTime!);
      _startTimer();
    } else {
      _checkInTime = null;
      _elapsed = Duration.zero;
    }
    notifyListeners();
  }

  Future<void> checkIn() async {
    _checkInTime = DateTime.now();
    _isCheckedIn = true;
    _checkInDate = DateFormat('EEE, MMM d, yyyy').format(_checkInTime!);
    _checkInTimeString = DateFormat('hh:mm:ss a').format(_checkInTime!);

    await _storage.write(key: 'isCheckedIn', value: 'true');
    await _storage.write(key: 'checkInTime', value: _checkInTime!.toIso8601String());

    _elapsed = Duration.zero;
    _startTimer();
    notifyListeners();
  }

  Future<void> checkOut() async {
    _isCheckedIn = false;
    _elapsed = DateTime.now().difference(_checkInTime ?? DateTime.now());
    final total = _formatDuration(_elapsed);

    await _storage.delete(key: 'isCheckedIn');
    await _storage.delete(key: 'checkInTime');
    _timer?.cancel();

    notifyListeners();
    debugPrint("Total Work Time: $total");
  }

  Future<void> saveBreakState(bool isOnBreak, Duration currentDisplayedBreakDuration) async {
    final accumulatedStr = await _storage.read(key: 'accumulatedBreakSeconds');
    final accumulated = int.tryParse(accumulatedStr ?? '0') ?? 0;

    if (isOnBreak) {
      await _storage.write(key: 'isOnBreak', value: 'true');
      final existingStart = await _storage.read(key: 'breakStartTime');
      if (existingStart == null) {
        final start = DateTime.now().subtract(Duration(seconds: accumulated));
        await _storage.write(key: 'breakStartTime', value: start.toIso8601String());
      }
    } else {
      final startStr = await _storage.read(key: 'breakStartTime');
      int extra = 0;
      if (startStr != null) {
        final start = DateTime.tryParse(startStr);
        if (start != null) {
          extra = DateTime.now().difference(start).inSeconds;
        }
      }
      final total = accumulated + extra;
      await _storage.write(key: 'accumulatedBreakSeconds', value: total.toString());
      await _storage.delete(key: 'breakStartTime');
      await _storage.write(key: 'isOnBreak', value: 'false');
    }
  }

  Future<bool> getBreakStatus() async {
    final status = await _storage.read(key: 'isOnBreak');
    return status == 'true';
  }

  Future<Duration> getBreakDuration() async {
    final accumulatedStr = await _storage.read(key: 'accumulatedBreakSeconds');
    final accumulated = int.tryParse(accumulatedStr ?? '0') ?? 0;
    final startStr = await _storage.read(key: 'breakStartTime');
    if (startStr != null) {
      final start = DateTime.tryParse(startStr);
      if (start != null) {
        final running = DateTime.now().difference(start).inSeconds;
        return Duration(seconds: accumulated + running);
      }
    }
    return Duration(seconds: accumulated);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_checkInTime != null && _isCheckedIn) {
        _elapsed = DateTime.now().difference(_checkInTime!);
        notifyListeners();
      }
    });
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
