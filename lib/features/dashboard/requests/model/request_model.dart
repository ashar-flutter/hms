import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String? fileUrl;
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String? userProfileImage;
  final String userRole;
  final String userFirstName;
  final String userLastName;
  final String category;
  final String type;
  final String reason;
  final String description;
  final String? filePath;
  final String? fileName;
  final String? fileData;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String status;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final int leaveCount;

  RequestModel({
    String? id,
    this.fileUrl,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
    required this.userRole,
    required this.userFirstName,
    required this.userLastName,
    required this.category,
    required this.type,
    required this.reason,
    required this.description,
    this.filePath,
    this.fileName,
    this.fileData,
    this.fromDate,
    this.toDate,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
    this.leaveCount = 1,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() {
    return {
      'fileUrl': fileUrl,
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userProfileImage': userProfileImage,
      'userRole': userRole,
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'category': category,
      'type': type,
      'reason': reason,
      'description': description,
      'filePath': filePath,
      'fileName': fileName,
      'fileData': fileData,
      'fromDate': fromDate?.millisecondsSinceEpoch,
      'toDate': toDate?.millisecondsSinceEpoch,
      'status': status,
      'createdAt':
          createdAt?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'leaveCount': leaveCount,
    };
  }

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    String? fileData = json['fileData'];
    if (fileData != null && fileData.length > 300000) {
      fileData = null;
    }

    Timestamp? createdAt;
    if (json['createdAt'] is Timestamp) {
      createdAt = json['createdAt'];
    } else if (json['createdAt'] is int) {
      createdAt = Timestamp.fromMillisecondsSinceEpoch(json['createdAt']);
    }

    Timestamp? updatedAt;
    if (json['updatedAt'] is Timestamp) {
      updatedAt = json['updatedAt'];
    } else if (json['updatedAt'] is int) {
      updatedAt = Timestamp.fromMillisecondsSinceEpoch(json['updatedAt']);
    }

    return RequestModel(
      fileUrl: json['fileUrl'],
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'] ?? '',
      userProfileImage: json['userProfileImage'],
      userRole: json['userRole'] ?? 'employee',
      userFirstName: json['userFirstName'] ?? '',
      userLastName: json['userLastName'] ?? '',
      category: json['category'],
      type: json['type'],
      reason: json['reason'],
      description: json['description'],
      filePath: json['filePath'],
      fileName: json['fileName'],
      fileData: fileData,
      fromDate: json['fromDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['fromDate'])
          : null,
      toDate: json['toDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['toDate'])
          : null,
      status: json['status'] ?? 'pending',
      createdAt: createdAt,
      updatedAt: updatedAt,
      leaveCount: json['leaveCount'] ?? 1,
    );
  }

  @override
  String toString() {
    return 'RequestModel{id: $id, user: $userName, category: $category, status: $status, leaveCount: $leaveCount}';
  }
}
