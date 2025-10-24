import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUserService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.isEmpty) return [];

    final result = await _firestore.collection('users').get();

    return result.docs.map((doc) {
      final data = doc.data();
      return {
        ...data,
        'userId': doc.id,
      };
    }).where((data) {
      final fullName = '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'
          .toLowerCase();
      return fullName.contains(query.toLowerCase());
    }).toList();
  }
}