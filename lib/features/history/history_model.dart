class LeaveHistory {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String category;
  final String type;
  final String reason;
  final String description;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String status;
  final int leaveCount;
  final DateTime createdAt;
  final String? fileName;
  final String? fileUrl;

  LeaveHistory({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.category,
    required this.type,
    required this.reason,
    required this.description,
    this.fromDate,
    this.toDate,
    required this.status,
    required this.leaveCount, // ✅ Agar yeh required int hai toh problem solve
    required this.createdAt,
    this.fileName,
    this.fileUrl,
  });

  factory LeaveHistory.fromJson(Map<String, dynamic> json) {
    return LeaveHistory(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      reason: json['reason'] ?? '',
      description: json['description'] ?? '',
      fromDate: json['fromDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['fromDate'])
          : null,
      toDate: json['toDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['toDate'])
          : null,
      status: json['status'] ?? 'pending',
      leaveCount: json['leaveCount'] ?? 1,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
          : DateTime.now(),
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'category': category,
      'type': type,
      'reason': reason,
      'description': description,
      'fromDate': fromDate?.millisecondsSinceEpoch,
      'toDate': toDate?.millisecondsSinceEpoch,
      'status': status,
      'leaveCount': leaveCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'fileName': fileName,
      'fileUrl': fileUrl,
    };
  }
}