import 'package:flutter/material.dart';
import '../controller/performance_controller.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  final PerformanceController _controller = PerformanceController();
  List<Map<String, dynamic>> _performanceData = [];

  @override
  void initState() {
    super.initState();
    _loadPerformanceData();
  }

  Future<void> _loadPerformanceData() async {
    final data = await _controller.getUserPerformanceData();
    if (mounted) {
      setState(() {
        _performanceData = data;
      });
    }
  }

  double _parseWorkDuration(String duration) {
    try {
      final parts = duration.split(':');
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      final seconds = int.parse(parts[2]);
      return hours + (minutes / 60) + (seconds / 3600);
    } catch (e) {
      return 0.0;
    }
  }

  Widget _buildCustomGraph() {
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

    final maxHours = _performanceData
        .map((data) => _parseWorkDuration(data['workDuration'] ?? '00:00:00'))
        .fold(0.0, (max, hours) => hours > max ? hours : max);

    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _performanceData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final hours = _parseWorkDuration(data['workDuration'] ?? '00:00:00');
          final heightPercentage = maxHours > 0 ? (hours / maxHours) : 0.0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 20,
                height: 200 * heightPercentage.toDouble(),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5038ED), Color(0xFF8B78FF)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: 40,
                child: Text(
                  '${hours.toStringAsFixed(1)}h',
                  style: TextStyle(
                    fontFamily: "poppins",
                    fontSize: 10,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 4),
              Container(
                width: 40,
                child: Text(
                  'Day ${index + 1}',
                  style: TextStyle(
                    fontFamily: "poppins",
                    fontSize: 9,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Performance Graph",
                  style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Last ${_performanceData.length} Days",
                  style: TextStyle(
                    fontFamily: "poppins",
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _buildCustomGraph(),
          ),
        ],
      ),
    );
  }
}