import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'history_model.dart';

class HistoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<LeaveHistory> _allHistory = <LeaveHistory>[].obs;
  final RxString _selectedFilter = 'all'.obs;

  List<LeaveHistory> get allHistory => _allHistory;
  String get selectedFilter => _selectedFilter.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserHistory();
  }

  void _loadUserHistory() {
    final userId = _getCurrentUserId();

    _firestore
        .collection('leave_history')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _allHistory.value = snapshot.docs.map((doc) {
        return LeaveHistory.fromJson(doc.data());
      }).toList();
    });
  }

  String _getCurrentUserId() {
    return _auth.currentUser?.uid ?? 'unknown_user';
  }

  List<LeaveHistory> get filteredHistory {
    if (_selectedFilter.value == 'all') {
      return _allHistory;
    }
    return _allHistory.where((history) => history.status == _selectedFilter.value).toList();
  }

  void setFilter(String filter) {
    _selectedFilter.value = filter;
  }

  int get totalRequests => _allHistory.length;
  int get approvedCount => _allHistory.where((h) => h.status == 'approved').length;
  int get pendingCount => _allHistory.where((h) => h.status == 'pending').length;
  int get rejectedCount => _allHistory.where((h) => h.status == 'rejected').length;

  int get totalLeaveDays => _allHistory
      .where((h) => h.status == 'approved')
      .fold(0, (total, history) => total + history.leaveCount);

  void refreshHistory() {
    _loadUserHistory();
  }
}