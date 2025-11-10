import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecord {
  final String userId;
  final String firstName;
  final String lastName;
  final String role;
  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  final String workDuration;
  final String breakDuration;
  final String status;
  final double lat;
  final double lng;
  final Timestamp timestamp;

  AttendanceRecord({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.workDuration,
    required this.breakDuration,
    required this.status,
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'date': date,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'workDuration': workDuration,
      'breakDuration': breakDuration,
      'status': status,
      'location': {'lat': lat, 'lng': lng},
      'timestamp': timestamp,
    };
  }

  static AttendanceRecord fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      role: map['role'] ?? '',
      date: map['date'] ?? '',
      checkInTime: map['checkInTime'],
      checkOutTime: map['checkOutTime'],
      workDuration: map['workDuration'] ?? '00:00:00',
      breakDuration: map['breakDuration'] ?? '00:00:00',
      status: map['status'] ?? '',
      lat: (map['location'] != null) ? map['location']['lat'] ?? 0.0 : 0.0,
      lng: (map['location'] != null) ? map['location']['lng'] ?? 0.0 : 0.0,
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }
}
