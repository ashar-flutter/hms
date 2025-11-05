import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentCountService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxInt pendingCount = 0.obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    _startListener();
  }

  void _startListener() {
    _subscription = _firestore
        .collection('documents')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      pendingCount.value = snapshot.docs.length;
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}