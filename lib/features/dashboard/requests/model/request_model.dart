class RequestModel {
  final String category;
  final String type;
  final String reason;
  final String description;
  final String? filePath;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? status;

  RequestModel({
    required this.category,
    required this.type,
    required this.reason,
    required this.description,
    this.filePath,
    this.fromDate,
    this.toDate,
    this.status,
  });
}
