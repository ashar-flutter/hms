import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class AttendanceHelper {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveCheckInTime(DateTime time) async {
    await _storage.write(key: 'checkInTime', value: time.toIso8601String());
    await _storage.write(key: 'isCheckedIn', value: 'true');
    await _storage.write(key: 'checkInDate', value: time.toIso8601String());
    await _storage.write(key: 'checkInTimeString', value: time.toIso8601String());
  }

  static Future<void> saveCheckOut() async {
    await _storage.delete(key: 'checkInTime');
    await _storage.delete(key: 'checkInDate');
    await _storage.delete(key: 'checkInTimeString');
    await _storage.write(key: 'isCheckedIn', value: 'false');
  }

  static Future<DateTime?> getCheckInTime() async {
    final value = await _storage.read(key: 'checkInTime');
    if (value == null) return null;
    return DateTime.parse(value);
  }

  static Future<String?> getCheckInDate() async {
    final value = await _storage.read(key: 'checkInDate');
    if (value == null) return null;
    final date = DateTime.parse(value);
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  static Future<String?> getCheckInTimeString() async {
    final value = await _storage.read(key: 'checkInTimeString');
    if (value == null) return null;
    final time = DateTime.parse(value);
    return DateFormat('hh:mm:ss a').format(time);
  }

  static Future<bool> isCheckedIn() async {
    final value = await _storage.read(key: 'isCheckedIn');
    return value == 'true';
  }

  // Break persistence methods
  static Future<void> saveBreakState(bool isOnBreak, Duration breakDuration) async {
    await _storage.write(key: 'isOnBreak', value: isOnBreak.toString());
    await _storage.write(key: 'breakDuration', value: breakDuration.inSeconds.toString());
  }

  static Future<bool> getBreakStatus() async {
    final value = await _storage.read(key: 'isOnBreak');
    return value == 'true';
  }

  static Future<Duration> getBreakDuration() async {
    final value = await _storage.read(key: 'breakDuration');
    if (value == null) return Duration.zero;
    return Duration(seconds: int.parse(value));
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}