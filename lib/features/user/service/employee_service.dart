import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> doesEmployeeExist() async {
    try {
      final userId = _auth.currentUser!.uid;
      final doc = await _firestore.collection('tech_employees').doc(userId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveEmployeeData({
    required String firstName,
    required String lastName,
    required String role,
    required String profileImage,
  }) async {
    try {
      final userId = _auth.currentUser!.uid;
      final email = _auth.currentUser!.email;

      await _firestore.collection('tech_employees').doc(userId).set({
        'userId': userId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
        'profileImage': profileImage,
        'joinedAt': FieldValue.serverTimestamp(),
        'termsAccepted': true,
        'termsAcceptedAt': FieldValue.serverTimestamp(),
        'status': 'active',
        'expertise': _getExpertiseByRole(role),
        'performance': {
          'tasksCompleted': 0,
          'onTimeAttendance': 0,
          'leavesTaken': 0,
          'lastCheckIn': null,
        }
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error saving employee data: $e');
    }
  }

  String _getExpertiseByRole(String role) {
    switch (role.toLowerCase()) {
      case 'flutter developer':
        return 'Mobile App Development, Dart, Flutter Framework';
      case 'mern stack developer':
        return 'MongoDB, Express.js, React, Node.js';
      case 'web developer':
        return 'HTML, CSS, JavaScript, Frontend Development';
      case 'java developer':
        return 'Java, Spring Boot, Backend Development';
      case 'react native developer':
        return 'Cross-platform Mobile Development, JavaScript';
      case 'ui/ux designer':
        return 'User Interface Design, User Experience, Figma';
      case 'digital marketer':
        return 'SEO, Social Media Marketing, Content Strategy';
      case 'seo specialist':
        return 'Search Engine Optimization, Analytics, Keywords';
      case 'project manager':
        return 'Project Planning, Team Management, Agile Methodology';
      case 'content writer':
        return 'Content Creation, SEO Writing, Blog Writing';
      default:
        return 'General IT Services';
    }
  }

  Stream<QuerySnapshot> getAllTechEmployees() {
    return _firestore.collection('tech_employees').snapshots();
  }

  Future<Map<String, dynamic>?> getEmployeeDetails(String userId) async {
    try {
      final doc = await _firestore.collection('tech_employees').doc(userId).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }
}