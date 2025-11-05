import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DocumentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitDocument({
    required String docName,
    required String docType,
    required String expiryDate,
    required String fileName,
    required String filePath,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      await _firestore.collection('documents').add({
        'userId': user.uid,
        'userEmail': user.email,
        'docName': docName,
        'docType': docType,
        'expiryDate': expiryDate,
        'fileName': fileName,
        'filePath': filePath,
        'status': 'pending',
        'submittedAt': FieldValue.serverTimestamp(),
        'adminResponse': null,
        'respondedAt': null,
      });
    } catch (e) {
      throw Exception("Failed to submit document: $e");
    }
  }

  Stream<QuerySnapshot> getUserDocuments() {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    return _firestore
        .collection('documents')
        .where('userId', isEqualTo: user.uid)
        .orderBy('submittedAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllDocuments() {
    return _firestore
        .collection('documents')
        .orderBy('submittedAt', descending: true)
        .snapshots();
  }

  Future<void> respondToDocument({
    required String docId,
    required String status,
    required String adminResponse,
  }) async {
    try {
      await _firestore.collection('documents').doc(docId).update({
        'status': status,
        'adminResponse': adminResponse,
        'respondedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to respond to document: $e");
    }
  }
}