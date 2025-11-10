import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../chats/widgets/custom_bar.dart';
import '../controllers/admin_attendance_controller.dart';

class ActiveEmployeesScreen extends StatelessWidget {
  final AdminAttendanceController controller = Get.find();

  ActiveEmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomBar(text: "Active today"),
      ),
      body: Obx(() {
        final employees = controller.activeEmployees;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today: ${DateFormat('EEE, MMM d, yyyy').format(DateTime.now())}',
                    style: const TextStyle(fontSize: 15, fontFamily: "bold"),
                  ),
                  Text(
                    'Total: ${employees.length}',
                    style: const TextStyle(fontSize: 14, fontFamily: "bold"),
                  ),
                ],
              ),
            ),
            if (employees.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No active employees today', style:
                  TextStyle(fontSize: 18, color: Colors.grey,
                  fontFamily: "poppins"
                  )),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: employees.length,
                  itemBuilder: (context, index) => _buildEmployeeCard(employees[index]),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> employee) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${employee['firstName']} ${employee['lastName']}',
                  style: const TextStyle(fontSize: 15, fontFamily: "bold"),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(employee['status']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    employee['status'] ?? 'Checked In',
                    style: const
                    TextStyle(color: Colors.white, fontSize: 12,
                        fontFamily: "poppins"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Role: ${employee['role']}',
                style: const TextStyle(color: Colors.grey,
                fontFamily: "bold"
                )),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoItem('Check In', employee['checkInTime'] ?? '--:--'),
                const SizedBox(width: 20),
                _buildInfoItem('Check Out', employee['checkOutTime'] ?? '--:--'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoItem('Work Time', employee['workDuration'] ?? '00:00:00'),
                const SizedBox(width: 20),
                _buildInfoItem('Break Time', employee['breakDuration'] ?? '00:00:00'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey,
        fontFamily: "poppins"
        )),
        Text(value, style:
        const TextStyle(fontSize: 14, fontFamily: "bold")),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Checked In': return Colors.green;
      case 'On Break': return Colors.orange;
      case 'Checked Out': return Colors.red;
      default: return Colors.blue;
    }
  }
}