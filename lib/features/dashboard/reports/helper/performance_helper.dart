import 'package:intl/intl.dart';

class PerformanceHelper {
  static double parseWorkDuration(String duration) {
    try {
      if (duration.isEmpty) return 0.0;
      final parts = duration.split(':');
      if (parts.length < 2) return 0.0;
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;
      return hours + (minutes / 60);
    } catch (e) {
      return 0.0;
    }
  }

  static double calculateLiveProgress(String? checkInTime, String? checkOutTime) {
    final now = DateTime.now();

    if (checkInTime == null || checkInTime == 'N/A') {
      return 0.0;
    }

    if (checkOutTime != null && checkOutTime != 'N/A') {
      return 100.0;
    }

    try {
      final checkInParts = checkInTime.split(':');
      final checkInHour = int.parse(checkInParts[0]);
      final checkInMinute = int.parse(checkInParts[1]);

      final checkInDateTime = DateTime(now.year, now.month, now.day, checkInHour, checkInMinute);
      final endTime = DateTime(now.year, now.month, now.day, 17, 0);

      final totalWorkDuration = endTime.difference(checkInDateTime).inMinutes;
      final completedDuration = now.difference(checkInDateTime).inMinutes;

      if (totalWorkDuration <= 0) return 100.0;

      double progress = (completedDuration / totalWorkDuration) * 100;
      return progress.clamp(0.0, 100.0);
    } catch (e) {
      return 0.0;
    }
  }

  static List<Map<String, dynamic>> getLiveWeeklyData(List<Map<String, dynamic>> performanceData) {
    final now = DateTime.now();
    final List<Map<String, dynamic>> weekData = [];
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (int i = 6; i >= 0; i--) {
      final dayDate = DateTime(now.year, now.month, now.day - i);
      final dateStr = DateFormat('yyyy-MM-dd').format(dayDate);

      final dayRecord = performanceData.firstWhere(
            (data) => data['date'] == dateStr,
        orElse: () => {'workDuration': '0:00', 'checkInTime': null},
      );

      final hours = parseWorkDuration(dayRecord['workDuration'] ?? '0:00');
      final isToday = dayDate.day == now.day;

      weekData.add({
        'dayName': dayNames[dayDate.weekday - 1],
        'hours': hours,
        'isToday': isToday,
        'date': dateStr,
        'fullDate': DateFormat('MMM d').format(dayDate),
      });
    }

    return weekData;
  }

  static Map<String, dynamic> calculateLiveMonthlyMetrics(List<Map<String, dynamic>> performanceData) {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    int totalWorkingDays = DateTime(now.year, now.month + 1, 0).day;
    int presentDays = 0;
    int onTimeDays = 0;
    double totalHours = 0.0;

    for (final data in performanceData) {
      if (data['date'] != null) {
        try {
          final date = DateFormat('yyyy-MM-dd').parse(data['date']);
          if (date.month == currentMonth && date.year == currentYear) {
            if (data['checkInTime'] != null && data['checkInTime'] != 'N/A') {
              presentDays++;

              final checkInTime = data['checkInTime'];
              final timeParts = checkInTime.split(':');
              final hour = int.parse(timeParts[0]);
              final minute = int.parse(timeParts[1]);

              if (hour < 9 || (hour == 9 && minute <= 30)) {
                onTimeDays++;
              }

              if (data['workDuration'] != null) {
                totalHours += parseWorkDuration(data['workDuration']);
              }
            }
          }
        } catch (e) {
          continue;
        }
      }
    }

    final attendancePercentage = totalWorkingDays > 0 ? (presentDays / totalWorkingDays) * 100 : 0;
    final punctualityPercentage = presentDays > 0 ? (onTimeDays / presentDays) * 100 : 0;

    return {
      'attendance': attendancePercentage.roundToDouble(),
      'punctuality': punctualityPercentage.roundToDouble(),
      'totalHours': totalHours,
      'presentDays': presentDays,
      'totalWorkingDays': totalWorkingDays,
    };
  }

  static List<Map<String, dynamic>> getWeeklyPunctuality(List<Map<String, dynamic>> performanceData) {
    final now = DateTime.now();
    final List<Map<String, dynamic>> weekData = [];

    for (int i = 0; i < 4; i++) {
      final weekStart = DateTime(now.year, now.month, now.day - (now.weekday - 1) - (i * 7));
      int weekScore = 0;
      int daysPresent = 0;

      for (int j = 0; j < 5; j++) {
        final dayDate = DateTime(weekStart.year, weekStart.month, weekStart.day + j);
        final dateStr = DateFormat('yyyy-MM-dd').format(dayDate);

        final dayRecord = performanceData.firstWhere(
              (data) => data['date'] == dateStr,
          orElse: () => {'checkInTime': null},
        );

        if (dayRecord['checkInTime'] != null) {
          daysPresent++;
          final checkInTime = dayRecord['checkInTime'];
          final timeParts = checkInTime.split(':');
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);

          if (hour < 9 || (hour == 9 && minute <= 30)) {
            weekScore += 10;
          } else {
            weekScore += 5;
          }
        }
      }

      weekData.add({
        'week': 'Week ${i + 1}',
        'score': daysPresent > 0 ? (weekScore / daysPresent).round() : 0,
      });
    }

    return weekData.reversed.toList();
  }
}