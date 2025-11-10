import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../service/check_service.dart';

class CheckController extends ChangeNotifier {
  final CheckService _checkService = CheckService();

  Future<void> recordCheck({
    required bool isCheckIn,
    required Duration workDuration,
    required Duration breakDuration,
    required LatLng currentPosition,
    String? existingCheckInTime,
  }) async {
    final now = DateTime.now();
    final date = DateFormat('yyyy-MM-dd').format(now);
    final checkInTime =
    isCheckIn ? DateFormat('hh:mm:ss a').format(now) : existingCheckInTime;
    final checkOutTime =
    isCheckIn ? null : DateFormat('hh:mm:ss a').format(now);

    await _checkService.saveCheckStatus(
      date: date,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      workDuration: _formatDuration(workDuration),
      breakDuration: _formatDuration(breakDuration),
      status: isCheckIn ? "Checked In" : "Checked Out",
      lat: currentPosition.latitude,
      lng: currentPosition.longitude,
    );
  }

  Future<void> recordBreak({
    required bool isOnBreak,
    required Duration workDuration,
    required Duration breakDuration,
    required LatLng currentPosition,
    required String date,
    required String? checkInTime,
    required String? checkOutTime,
  }) async {
    await _checkService.saveCheckStatus(
      date: date,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      workDuration: _formatDuration(workDuration),
      breakDuration: _formatDuration(breakDuration),
      status: isOnBreak ? "On Break" : "Working",
      lat: currentPosition.latitude,
      lng: currentPosition.longitude,
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }
}