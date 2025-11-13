import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureAttendanceService {
  static const _storage = FlutterSecureStorage();
  static const _totalBreakKey = 'totalBreakDuration';

  static const _checkInKey = 'checkInTime';
  static const _checkOutKey = 'checkOutTime';
  static const _isCheckedInKey = 'isCheckedIn';
  static const _breakStartKey = 'breakStartTime';
  static const _isOnBreakKey = 'isOnBreak';

  Future<void> saveTotalBreakDuration(Duration duration) async {
    await _storage.write(
      key: _totalBreakKey,
      value: duration.inSeconds.toString(),
    );
  }

  Future<Duration> getTotalBreakDuration() async {
    final value = await _storage.read(key: _totalBreakKey);
    if (value != null) return Duration(seconds: int.parse(value));
    return Duration.zero;
  }

  Future<void> clearTotalBreak() async {
    await _storage.delete(key: _totalBreakKey);
  }

  Future<void> saveBreakStartTime(DateTime time) async {
    await _storage.write(key: _breakStartKey, value: time.toIso8601String());
  }

  Future<void> saveBreakStatus(bool isOnBreak) async {
    await _storage.write(key: _isOnBreakKey, value: isOnBreak.toString());
  }

  Future<DateTime?> getBreakStartTime() async {
    final value = await _storage.read(key: _breakStartKey);
    if (value != null) return DateTime.parse(value);
    return null;
  }

  Future<bool> isOnBreak() async {
    final value = await _storage.read(key: _isOnBreakKey);
    return value == 'true';
  }

  Future<void> clearBreakData() async {
    await _storage.delete(key: _breakStartKey);
    await _storage.delete(key: _isOnBreakKey);
  }

  Future<void> saveCheckInTime(DateTime time) async {
    await _storage.write(key: _checkInKey, value: time.toIso8601String());
    await _storage.delete(key: _checkOutKey);
    await _storage.write(key: _isCheckedInKey, value: 'true');
  }

  Future<void> saveCheckOutTime(DateTime time) async {
    await _storage.write(key: _checkOutKey, value: time.toIso8601String());
    await _storage.write(key: _isCheckedInKey, value: 'false');
  }

  Future<DateTime?> getCheckInTime() async {
    final value = await _storage.read(key: _checkInKey);
    if (value != null) return DateTime.parse(value);
    return null;
  }

  Future<DateTime?> getCheckOutTime() async {
    final value = await _storage.read(key: _checkOutKey);
    if (value != null) return DateTime.parse(value);
    return null;
  }

  Future<bool> isCheckedIn() async {
    final value = await _storage.read(key: _isCheckedInKey);
    return value == 'true';
  }

  Future<void> clearTimes() async {
    await _storage.delete(key: _checkInKey);
    await _storage.delete(key: _checkOutKey);
    await _storage.delete(key: _isCheckedInKey);
  }
}
