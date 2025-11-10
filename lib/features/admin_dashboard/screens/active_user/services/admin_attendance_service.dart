import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getLiveAttendanceStream() {
    final today = _getTodayDate();
    return _firestore
        .collectionGroup('records')
        .where('date', isEqualTo: today)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> getTodayActiveUsers() async {
    final today = _getTodayDate();
    final snapshot = await _firestore
        .collectionGroup('records')
        .where('date', isEqualTo: today)
        .where('checkInTime', isNotEqualTo: null)
        .get();

    final usersMap = <String, Map<String, dynamic>>{};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final userId = data['userId'] as String? ?? '';
      final checkOutTime = data['checkOutTime'];

      if (userId.isNotEmpty && data['role'] != 'admin') {
        if (!usersMap.containsKey(userId) || _isNewerRecord(doc['timestamp'], usersMap[userId]!['lastUpdate'])) {
          usersMap[userId] = {
            'userId': userId,
            'firstName': data['firstName'] ?? '',
            'lastName': data['lastName'] ?? '',
            'role': data['role'] ?? 'employee',
            'checkInTime': data['checkInTime'] ?? '',
            'checkOutTime': checkOutTime ?? '',
            'breakDuration': data['breakDuration'] ?? '00:00:00',
            'workDuration': data['workDuration'] ?? '00:00:00',
            'status': checkOutTime == null ? 'Checked In' : 'Checked Out',
            'lastUpdate': doc['timestamp'],
          };
        }
      }
    }

    return usersMap.values.toList();
  }

  Future<List<Map<String, dynamic>>> getCurrentlyActiveUsers() async {
    final allUsers = await getTodayActiveUsers();
    return allUsers.where((user) => user['checkOutTime'] == '').toList();
  }

  bool _isNewerRecord(Timestamp newTime, Timestamp existingTime) {
    return newTime.millisecondsSinceEpoch > existingTime.millisecondsSinceEpoch;
  }

  String _getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}