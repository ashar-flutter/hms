import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/reports_controller.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ReportsController _controller = ReportsController();
  List<Map<String, dynamic>> _reportsData = [];
  DateTime _currentDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('EEE, MMM d, yyyy');

  @override
  void initState() {
    super.initState();
    _loadReportsData();
  }

  Future<void> _loadReportsData() async {
    final data = await _controller.getUserReports();
    if (mounted) {
      setState(() {
        _reportsData = data;
      });
    }
  }

  void _navigateToPreviousDate() {
    setState(() {
      _currentDate = _currentDate.subtract(Duration(days: 1));
    });
  }

  void _navigateToNextDate() {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: 1));
    });
  }

  String _formatDateForQuery(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final currentDateStr = _formatDateForQuery(_currentDate);
    final todayReport = _reportsData.firstWhere(
          (report) => report['date'] == currentDateStr,
      orElse: () => {},
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _navigateToPreviousDate,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                Text(
                  _dateFormat.format(_currentDate),
                  style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: _navigateToNextDate,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: todayReport.isEmpty
                ? Center(
              child: Text(
                "No report available for this date",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            )
                : ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildReportCard(
                  title: "Check In Time",
                  value: todayReport['checkInTime'] ?? 'N/A',
                  icon: Icons.login_rounded,
                  color: Color(0xFF10B981),
                ),
                SizedBox(height: 12),
                _buildReportCard(
                  title: "Check Out Time",
                  value: todayReport['checkOutTime'] ?? 'N/A',
                  icon: Icons.logout_rounded,
                  color: Color(0xFFEF4444),
                ),
                SizedBox(height: 12),
                _buildReportCard(
                  title: "Work Duration",
                  value: todayReport['workDuration'] ?? '00:00:00',
                  icon: Icons.access_time_rounded,
                  color: Color(0xFF5038ED),
                ),
                SizedBox(height: 12),
                _buildReportCard(
                  title: "Break Duration",
                  value: todayReport['breakDuration'] ?? '00:00:00',
                  icon: Icons.free_breakfast_rounded,
                  color: Color(0xFFF59E0B),
                ),
                SizedBox(height: 12),
                _buildReportCard(
                  title: "Status",
                  value: todayReport['status'] ?? 'N/A',
                  icon: Icons.work_history_rounded,
                  color: Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: "poppins",
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}