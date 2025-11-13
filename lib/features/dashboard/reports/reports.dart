import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/dashboard/reports/pages/report_bar.dart';
import 'package:intl/intl.dart';
import 'controller/performance_controller.dart';
import 'controller/reports_controller.dart';
import 'helper/performance_helper.dart';
import 'helper/reports_helper.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  bool isPerformanceSelected = true;
  final PerformanceController _performanceController = PerformanceController();
  final ReportsController _reportsController = ReportsController();
  List<Map<String, dynamic>> _performanceData = [];
  List<Map<String, dynamic>> _reportsData = [];
  List<DateTime> _attendanceDates = [];
  int _currentDateIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final performanceData = await _performanceController.getUserPerformanceData();
    final reportsData = await _reportsController.getUserReports();

    if (mounted) {
      setState(() {
        _performanceData = performanceData;
        _reportsData = reportsData;
        _attendanceDates = ReportsHelper.getAttendanceDatesOnly(reportsData);
        if (_attendanceDates.isNotEmpty) {
          _currentDateIndex = 0;
        }
      });
    }
  }

  Map<String, dynamic> _getTodayData() {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      return _performanceData.firstWhere(
            (data) => data['date'] == todayStr,
        orElse: () => {
          'checkInTime': null,
          'checkOutTime': null,
          'workDuration': '0:00'
        },
      );
    } catch (e) {
      return {
        'checkInTime': null,
        'checkOutTime': null,
        'workDuration': '0:00'
      };
    }
  }

  Widget _buildLiveCircularProgress() {
    final todayData = _getTodayData();
    final checkInTime = todayData['checkInTime'];
    final checkOutTime = todayData['checkOutTime'];

    final progress = PerformanceHelper.calculateLiveProgress(checkInTime, checkOutTime);
    final workedHours = PerformanceHelper.parseWorkDuration(todayData['workDuration'] ?? '0:00');

    return Column(
      children: [
        Container(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress / 100,
                strokeWidth: 14,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 90 ? Color(0xFF10B981) :
                  progress >= 50 ? Color(0xFFF59E0B) :
                  Color(0xFFEF4444),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${progress.toInt()}%',
                    style: TextStyle(
                      fontFamily: "bold",
                      fontSize: 24,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Worked: ${workedHours.toStringAsFixed(1)}h',
          style: TextStyle(
            fontFamily: "bold",
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        if (checkInTime != null) ...[
          SizedBox(height: 6),
          Text(
            'Checked In: $checkInTime',
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 12,
              color: Colors.green.shade600,
            ),
          ),
        ],
        if (checkOutTime != null) ...[
          SizedBox(height: 6),
          Text(
            'Checked Out: $checkOutTime',
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 12,
              color: Colors.red.shade600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLiveWeeklyGraph() {
    final weekData = PerformanceHelper.getLiveWeeklyData(_performanceData);
    final maxHours = 9.0;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "This Week Hours",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Daily work hours tracking",
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekData.map((data) {
                final hours = data['hours'];
                final dayName = data['dayName'];
                final isToday = data['isToday'];
                final fullDate = data['fullDate'];

                final barHeight = (hours / maxHours) * 150;
                final minBarHeight = 8.0;

                return Column(
                  children: [
                    Text(
                      '${hours.toStringAsFixed(1)}h',
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      width: 28,
                      height: barHeight > minBarHeight ? barHeight : minBarHeight,
                      decoration: BoxDecoration(
                        gradient: isToday
                            ? LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF34D399)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        )
                            : LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            fontFamily: "bold",
                            fontSize: 13,
                            color: isToday ? Color(0xFF10B981) : Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          fullDate,
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeTrackingCard(double totalHours) {
    final days = totalHours ~/ 8;
    final hours = totalHours % 8;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Daily Check-in & Check-out",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Time",
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "$days:${hours.toStringAsFixed(0)} Days",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 24,
              color: Color(0xFF10B981),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Employee time tracking over the month",
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "GROWTH",
                style: TextStyle(
                  fontFamily: "bold",
                  fontSize: 12,
                  color: Color(0xFF10B981),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_upward_rounded, size: 16, color: Color(0xFF10B981)),
              SizedBox(width: 8),
              Text(
                "GROWN",
                style: TextStyle(
                  fontFamily: "bold",
                  fontSize: 12,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyPunctualityGraph(List<Map<String, dynamic>> weeklyData) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Attendance",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Weekly punctuality comparison",
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weeklyData.map((data) {
                final score = data['score'] ?? 0;
                final week = data['week'] ?? '';

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      score.toString(),
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 25,
                      height: (score / 30) * 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF34D399)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      week,
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(double attendance, double punctuality) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Attendance & Punctuality",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Monthly performance metrics",
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricCircle(attendance, "Attendance"),
              _buildMetricCircle(punctuality, "Punctuality"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCircle(double percentage, String label) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage >= 90 ? Color(0xFF10B981) :
                  percentage >= 70 ? Color(0xFFF59E0B) :
                  Color(0xFFEF4444),
                ),
              ),
              Text(
                '${percentage.toInt()}%',
                style: TextStyle(
                  fontFamily: "bold",
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: "poppins",
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceView() {
    if (_performanceData.isEmpty) {
      return Center(
        child: Text(
          "No performance data available",
          style: TextStyle(
            fontFamily: "poppins",
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    final monthlyMetrics = PerformanceHelper.calculateLiveMonthlyMetrics(_performanceData);
    final weeklyData = PerformanceHelper.getWeeklyPunctuality(_performanceData);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 20),
          _buildLiveCircularProgress(),
          SizedBox(height: 30),
          _buildLiveWeeklyGraph(),
          SizedBox(height: 20),
          _buildWeeklyPunctualityGraph(weeklyData),
          SizedBox(height: 20),
          _buildPerformanceMetrics(
            monthlyMetrics['attendance'] ?? 0,
            monthlyMetrics['punctuality'] ?? 0,
          ),
        ],
      ),
    );
  }

  void _navigateToPreviousDate() {
    if (_currentDateIndex < _attendanceDates.length - 1) {
      setState(() {
        _currentDateIndex++;
      });
    }
  }

  void _navigateToNextDate() {
    if (_currentDateIndex > 0) {
      setState(() {
        _currentDateIndex--;
      });
    }
  }

  Widget _buildReportsView() {
    if (_attendanceDates.isEmpty) {
      return Center(
        child: Text(
          "No attendance records found",
          style: TextStyle(
            fontFamily: "poppins",
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    final currentDate = _attendanceDates[_currentDateIndex];
    final todayReport = ReportsHelper.findReportForDate(_reportsData, currentDate);

    return Column(
      children: [
        SizedBox(height: 20),
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
                ReportsHelper.formatDateDisplay(currentDate),
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
        SizedBox(height: 20),
        Expanded(
          child: todayReport == null
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
            child: Icon(icon, color: color, size: 24),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(size: 20, Icons.arrow_back),
          ),
          centerTitle: true,
          title: const Text(
            "Reports & Performance",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          ReportBarWithCallback(
            isPerformanceSelected: isPerformanceSelected,
            onTabChanged: (bool selectedPerformance) {
              setState(() {
                isPerformanceSelected = selectedPerformance;
              });
            },
          ),
          Expanded(
            child: isPerformanceSelected ? _buildPerformanceView() : _buildReportsView(),
          ),
        ],
      ),
    );
  }
}