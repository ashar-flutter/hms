import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import '../requests/controller/notification_controller.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('notifications',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontFamily: "bold"
        ),
        ),
        actions: [
          Obx(() => controller.unreadCount.value > 0
              ? TextButton(
            onPressed: () => controller.markAllAsRead(),
            child: Text('Mark All Read', style: TextStyle(color: Colors.blue)),
          )
              : SizedBox()),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.notification, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return _buildNotificationItem(notification);
          },
        );
      }),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] ?? false;
    final timestamp = notification['createdAt'] != null
        ? DateFormat('MMM dd, hh:mm a').format((notification['createdAt'] as Timestamp).toDate())
        : '';

    Color bgColor = isRead ? Colors.white : Colors.blue.shade50;
    IconData icon = notification['type'] == 'approval' ? Iconsax.tick_circle : Iconsax.close_circle;
    Color iconColor = notification['type'] == 'approval' ? Colors.green : Colors.red;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: bgColor,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          notification['title'] ?? 'Notification',
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification['message'] ?? ''),
            SizedBox(height: 4),
            Text(
              timestamp,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        )
            : null,
        onTap: () {
          if (!isRead) {
            controller.markAsRead(notification['id']);
          }
        },
      ),
    );
  }
}