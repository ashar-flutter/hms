import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureAttendanceService {
  static const _storage = FlutterSecureStorage();
  static const _checkInKey = 'checkInTime';
  static const _checkOutKey = 'checkOutTime';
  static const _isCheckedInKey = 'isCheckedIn';

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