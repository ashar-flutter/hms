import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../../../admin_dashboard/screens/employee_documents/pdupload_service.dart';
import '../../../admin_dashboard/services/lib/services/imgbb_service.dart';

class DocumentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitDocument({
    required String docName,
    required String docType,
    required String expiryDate,
    required String fileName,
    required String filePath,
    required bool isPdf,

  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      String? fileUrl;
      if (filePath.isNotEmpty) {
        final file = XFile(filePath);
        if (isPdf) {
          fileUrl = await PDUploadService.uploadFile(file);
          print('📄 PDF uploaded to Supabase');
        } else {
          fileUrl = await ImgBBService.uploadFile(file);
          print('🖼️ Image uploaded to ImgBB');
        }
        if (fileUrl == null) {
          throw Exception("Failed to upload file");
        }
      }

      await _firestore.collection('documents').add({
        'userId': user.uid,
        'userEmail': user.email,
        'docName': docName,
        'docType': docType,
        'expiryDate': expiryDate,
        'fileName': fileName,
        'filePath': filePath,
        'fileUrl': fileUrl,
        'fileType': isPdf ? 'pdf' : 'image',
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
