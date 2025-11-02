import 'dart:async';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestCountService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxInt pendingCount = 0.obs;
  final RxInt lastSeenCount = 0.obs;
  final RxBool hasVisitedRequests = false.obs;

  StreamSubscription? _countSubscription;

  @override
  void onInit() {
    super.onInit();
    _startRealtimeListener();
  }

  void _startRealtimeListener() {
    _countSubscription = _firestore
        .collection('leave_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      final newCount = snapshot.docs.length;
      pendingCount.value = newCount;

      if (lastSeenCount.value == 0) {
        lastSeenCount.value = newCount;
      }

      if (newCount > lastSeenCount.value) {
        hasVisitedRequests.value = false;
      }
    });
  }

  void markAsVisited() {
    hasVisitedRequests.value = true;
    lastSeenCount.value = pendingCount.value;
  }

  bool get shouldShowCount {
    return pendingCount.value > 0 &&
        (!hasVisitedRequests.value || pendingCount.value > lastSeenCount.value);
  }

  @override
  void onClose() {
    _countSubscription?.cancel();
    super.onClose();
  }
}