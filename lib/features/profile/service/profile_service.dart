import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveProfile({
    required String firstName,
    required String lastName,
    required String role,
    required String imagePath,
  }) async {
    final userId = _auth.currentUser!.uid;
    final bytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(bytes);

    await _firestore.collection('users').doc(userId).set({
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'profileImage': base64Image,
      'userId': userId,
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final userId = _auth.currentUser!.uid;
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) return doc.data();
    return null;
  }
}