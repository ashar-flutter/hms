import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserDocumentStatusService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxInt responseCount = 0.obs;
  StreamSubscription? _subscription;
  Set<String> _seenDocuments = {};
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    _loadSeenDocuments();
  }

  void _loadSeenDocuments() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final seenData = await _secureStorage.read(key: 'seenDocuments_${user.uid}');
    if (seenData != null) {
      final seenList = json.decode(seenData) as List<dynamic>;
      _seenDocuments = seenList.map((e) => e.toString()).toSet();
    }
    _startListener();
  }

  void _saveSeenDocuments() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _secureStorage.write(
      key: 'seenDocuments_${user.uid}',
      value: json.encode(_seenDocuments.toList()),
    );
  }

  void _startListener() {
    final user = _auth.currentUser;
    if (user == null) return;

    _subscription = _firestore
        .collection('documents')
        .where('userId', isEqualTo: user.uid)
        .where('status', whereIn: ['approved', 'rejected'])
        .snapshots()
        .listen((snapshot) {
      int newCount = 0;
      for (final doc in snapshot.docs) {
        if (!_seenDocuments.contains(doc.id)) {
          newCount++;
        }
      }
      responseCount.value = newCount;
    });
  }

  void markAllAsSeen() {
    final user = _auth.currentUser;
    if (user == null) return;

    _firestore
        .collection('documents')
        .where('userId', isEqualTo: user.uid)
        .where('status', whereIn: ['approved', 'rejected'])
        .get()
        .then((snapshot) {
      for (final doc in snapshot.docs) {
        _seenDocuments.add(doc.id);
      }
      _saveSeenDocuments();
      responseCount.value = 0;
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}