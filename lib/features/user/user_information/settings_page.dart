import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontFamily: "bold")),
        content: Text(content, style: const TextStyle(fontFamily: "poppins")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(fontFamily: "poppins")),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "bold",
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingItem("Change Password", Icons.lock, () {
            _showInfoDialog(
              context,
              "Change Password",
              "To change your password, please contact the HR department. They will assist you with the password reset process and ensure your account security.",
            );
          }),
          _buildSettingItem("Notification Settings", Icons.notifications, () {
            _showInfoDialog(
              context,
              "Notification Settings",
              "Manage your notification preferences here. You can enable/disable push notifications for attendance reminders, task updates, and company announcements.",
            );
          }),
          _buildSettingItem("Privacy Policy", Icons.privacy_tip, () {
            _showInfoDialog(
              context,
              "Privacy Policy",
              "LA Digital Agency respects your privacy. We collect only necessary data for attendance, task management, and communication. Your data is securely stored and never shared with third parties without your consent.",
            );
          }),
          _buildSettingItem("Terms & Conditions", Icons.description, () {
            _showInfoDialog(
              context,
              "Terms & Conditions",
              "By using this app, you agree to:\n• Maintain professional conduct\n• Mark attendance regularly\n• Complete assigned tasks on time\n• Follow company policies\n• Protect confidential information",
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.deepPurple, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontFamily: "poppins", color: Colors.black),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}