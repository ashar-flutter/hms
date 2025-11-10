import 'package:flutter/material.dart';
import '../../../chats/widgets/custom_bar.dart';

class AdminDetailScreen extends StatelessWidget {
  final String title;

  const AdminDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomBar(text: title),
      ),
      body: _buildDetailContent(title),
    );
  }

  Widget _buildDetailContent(String title) {
    switch (title) {
      case "LA Digital Agency":
        return _buildAgencyDetails();
      case "Email":
        return _buildEmailDetails();
      case "Address":
        return _buildAddressDetails();
      case "Contact":
        return _buildContactDetails();
      case "Team Management":
        return _buildTeamManagementDetails();
      case "Project Oversight":
        return _buildProjectOversightDetails();
      case "Performance Reviews":
        return _buildPerformanceReviewsDetails();
      case "Settings":
        return _buildSettingsDetails();
      default:
        return _buildDefaultDetails();
    }
  }

  Widget _buildAgencyDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard("🏢 Company Information", [
            "• LA Digital Agency - Model Town, Lahore",
            "• Founded: 2020",
            "• Industry: IT & Digital Solutions",
            "• Specialization: Mobile & Web Development",
            "• Team Size: 15+ Professionals",
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("📈 Services", [
            "• Mobile App Development (Flutter, React Native)",
            "• Web Development (MERN Stack, PHP, WordPress)",
            "• Digital Marketing & SEO",
            "• UI/UX Design",
            "• E-commerce Solutions",
          ]),
        ],
      ),
    );
  }

  Widget _buildEmailDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard("📧 Official Email", [
            "• Primary: LA@gmail.com",
            "• Support: support@ladigital.com",
            "• Business: business@ladigital.com",
            "• Response Time: Within 24 hours",
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("📞 Communication", [
            "• Official communications only",
            "• Project updates and discussions",
            "• Client meetings scheduling",
            "• Team coordination",
          ]),
        ],
      ),
    );
  }

  Widget _buildAddressDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard("📍 Office Location", [
            "• LA Digital Agency",
            "• Model Town, Lahore",
            "• Punjab, Pakistan",
            "• Landmark: Near Model Town Park",
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("🕒 Office Hours", [
            "• Monday - Friday: 9:00 AM - 6:00 PM",
            "• Saturday: 10:00 AM - 2:00 PM",
            "• Sunday: Closed",
            "• Emergency: Available on call",
          ]),
        ],
      ),
    );
  }

  Widget _buildContactDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard("📱 Contact Information", [
            "• Office: +92 300 1234567",
            "• WhatsApp: +92 300 1234567",
            "• Skype: ladigital.agency",
            "• Telegram: @ladigital",
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("🌐 Social Media", [
            "• LinkedIn: LA Digital Agency",
            "• Facebook: ladigitalagency",
            "• Instagram: ladigital.agency",
            "• Twitter: @ladigital",
          ]),
        ],
      ),
    );
  }

  Widget _buildTeamManagementDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard("👥 Team Management", [
            "• Total Employees: 15+",
            "• Departments: Development, Design, Marketing",
            "• Team Leads: 3",
            "• Remote Team: 5 members",
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("✅ Admin Responsibilities", [
            "• Assign tasks to team members",
            "• Monitor daily progress",
            "• Conduct team meetings",
            "• Resolve team conflicts",
            "• Performance tracking",
            "• Leave approvals",
          ]),
        ],
      ),
    );
  }

  Widget _buildProjectOversightDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard("📊 Project Oversight", [
            "• Active Projects: 8",
            "• Completed Projects: 25+",
            "• Ongoing Maintenance: 12 projects",
            "• Client Satisfaction: 95%",
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("🎯 Admin Responsibilities", [
            "• Monitor project timelines",
            "• Quality assurance checks",
            "• Client communication",
            "• Budget management",
            "• Risk assessment",
            "• Delivery coordination",
          ]),
        ],
      ),
    );
  }

  Widget _buildPerformanceReviewsDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard("📈 Performance Reviews", [
            "• Monthly evaluations",
            "• Quarterly assessments",
            "• Annual performance reviews",
            "• Skill development tracking",
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("✅ Admin Responsibilities", [
            "• Conduct employee evaluations",
            "• Provide constructive feedback",
            "• Set performance goals",
            "• Identify training needs",
            "• Career development planning",
            "• Promotion recommendations",
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("🎯 Evaluation Criteria", [
            "• Task completion rate",
            "• Quality of work",
            "• Team collaboration",
            "• Meeting deadlines",
            "• Client satisfaction",
            "• Skill improvement",
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard("⚙️ App Configuration", [
            "• User access controls",
            "• System preferences",
            "• Notification settings",
            "• Data management",
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("🔒 Security Settings", [
            "• Password policies",
            "• Session management",
            "• Data backup settings",
            "• Privacy controls",
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("📊 System Information", [
            "• App Version: 1.0.0",
            "• Last Updated: Today",
            "• Database: Firebase",
            "• Storage: Cloud Firestore",
          ]),
        ],
      ),
    );
  }

  Widget _buildDefaultDetails() {
    return const Center(
      child: Text(
        "Details not available",
        style: TextStyle(
          fontSize: 16,
          fontFamily: "poppins",
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDetailCard(String heading, List<String> points) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "bold",
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                point,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "poppins",
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
