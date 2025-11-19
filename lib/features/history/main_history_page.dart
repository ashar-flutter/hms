import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'history_controller.dart';
import 'history_model.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryController controller = Get.put(HistoryController());

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.purple.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              "Leave History",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "bold",
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => _showFilterDialog(context),
                icon: const Icon(
                  Icons.filter_list_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Statistics Cards
          _buildStatisticsCards(),
          const SizedBox(height: 16),

          // History List
          Expanded(child: Obx(() => _buildHistoryList())),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              "Total",
              controller.totalRequests.toString(),
              Colors.blue,
              Icons.history,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              "Approved",
              controller.approvedCount.toString(),
              Colors.green,
              Icons.check_circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              "Pending",
              controller.pendingCount.toString(),
              Colors.orange,
              Icons.pending,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: "bold",
              color: Colors.black87,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontFamily: "poppins",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    if (controller.filteredHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_toggle_off,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "No leave history found",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "poppins",
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.selectedFilter == 'all'
                  ? "You haven't applied for any leaves yet"
                  : "No ${controller.selectedFilter} leaves found",
              style: TextStyle(
                fontSize: 14,
                fontFamily: "poppins",
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.filteredHistory.length,
      itemBuilder: (context, index) {
        final history = controller.filteredHistory[index];
        return _buildHistoryCard(history);
      },
    );
  }

  Widget _buildHistoryCard(LeaveHistory history) {
    Color statusColor = Colors.orange;
    IconData statusIcon = Icons.pending;
    String statusText = 'Pending';

    if (history.status == 'approved') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Approved';
    } else if (history.status == 'rejected') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
      statusText = 'Rejected';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          history.category,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "bold",
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          history.type,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "poppins",
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "bold",
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Dates Row
              Row(
                children: [
                  _buildDateInfo("From", history.fromDate),
                  const SizedBox(width: 20),
                  _buildDateInfo("To", history.toDate),
                  const Spacer(),
                  _buildLeaveCount(history.leaveCount),
                ],
              ),

              const SizedBox(height: 12),

              // Reason
              if (history.reason.isNotEmpty) ...[
                Text(
                  "Reason: ${history.reason}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "poppins",
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              // Description
              if (history.description.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    history.description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "poppins",
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(history.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "poppins",
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (history.fileName != null)
                    Row(
                      children: [
                        Icon(
                          Icons.attach_file,
                          size: 14,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "File Attached",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "poppins",
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: "poppins",
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date != null ? DateFormat('dd/MM/yyyy').format(date) : 'N/A',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: "bold",
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveCount(int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "$count",
          style: const TextStyle(
            fontSize: 18,
            fontFamily: "bold",
            color: Colors.blue,
          ),
        ),
        Text(
          "day${count > 1 ? 's' : ''}",
          style: TextStyle(
            fontSize: 12,
            fontFamily: "poppins",
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Filter History",
          style: TextStyle(fontFamily: "bold"),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption("All", 'all'),
            _buildFilterOption("Pending", 'pending'),
            _buildFilterOption("Approved", 'approved'),
            _buildFilterOption("Rejected", 'rejected'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String text, String value) {
    return ListTile(
      leading: Obx(
        () => Radio<String>(
          value: value,
          groupValue: controller.selectedFilter,
          onChanged: (newValue) {
            controller.setFilter(newValue!);
            Get.back();
          },
        ),
      ),
      title: Text(text, style: const TextStyle(fontFamily: "poppins")),
      onTap: () {
        controller.setFilter(value);
        Get.back();
      },
    );
  }
}
