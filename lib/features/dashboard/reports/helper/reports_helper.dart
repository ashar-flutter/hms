import 'package:intl/intl.dart';

class ReportsHelper {
  static String formatDateForQuery(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDateDisplay(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  static List<DateTime> getAttendanceDatesOnly(List<Map<String, dynamic>> reports) {
    final dates = <DateTime>[];

    for (final report in reports) {
      if (report['date'] != null && report['checkInTime'] != null) {
        try {
          final date = DateFormat('yyyy-MM-dd').parse(report['date']);
          dates.add(date);
        } catch (e) {
          continue;
        }
      }
    }

    dates.sort((a, b) => b.compareTo(a));
    return dates;
  }

  static Map<String, dynamic>? findReportForDate(List<Map<String, dynamic>> reports, DateTime date) {
    final dateStr = formatDateForQuery(date);
    try {
      return reports.firstWhere((report) => report['date'] == dateStr);
    } catch (e) {
      return null;
    }
  }
}