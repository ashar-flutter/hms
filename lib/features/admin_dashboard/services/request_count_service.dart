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
    print('🟢 RequestCountService initialized');
    _startRealtimeListener();
  }

  void _startRealtimeListener() {
    print('📡 Starting request count listener...');

    _countSubscription = _firestore
        .collection('leave_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      final newCount = snapshot.docs.length;
      print('🔢 Request count updated: $newCount pending requests');

      pendingCount.value = newCount;

      // ✅ First time initialize lastSeenCount
      if (lastSeenCount.value == 0 && newCount > 0) {
        lastSeenCount.value = newCount;
        print('🔄 Last seen count initialized to: $newCount');
      }

      // ✅ Agar naye requests aaye hain to show count
      if (newCount > lastSeenCount.value) {
        hasVisitedRequests.value = false;
        print('🆕 New requests detected! Showing count badge');
      }

      // ✅ Debug info
      print('📊 Current: $newCount, Last Seen: ${lastSeenCount.value}, Has Visited: ${hasVisitedRequests.value}');
    }, onError: (error) {
      print('❌ Error in request count listener: $error');
    });
  }

  void markAsVisited() {
    print('📍 Marking requests as visited');
    hasVisitedRequests.value = true;
    lastSeenCount.value = pendingCount.value;
    print('✅ Last seen count updated to: ${pendingCount.value}');
  }

  bool get shouldShowCount {
    final shouldShow = pendingCount.value > 0 &&
        (!hasVisitedRequests.value || pendingCount.value > lastSeenCount.value);
    print('🎯 Should show count: $shouldShow');
    return shouldShow;
  }

  // ✅ MANUAL REFRESH METHOD
  Future<void> refreshCount() async {
    print('🔄 Manually refreshing request count...');
    try {
      final snapshot = await _firestore
          .collection('leave_requests')
          .where('status', isEqualTo: 'pending')
          .get();

      final newCount = snapshot.docs.length;
      pendingCount.value = newCount;
      print('✅ Manual refresh completed: $newCount pending requests');
    } catch (e) {
      print('❌ Error in manual refresh: $e');
    }
  }

  @override
  void onClose() {
    print('🔴 RequestCountService closed');
    _countSubscription?.cancel();
    super.onClose();
  }
}