enum LeaveStatus {
  PENDING,
  APPROVED,
  REJECTED,
  CANCELLED;

  factory LeaveStatus.fromString(String value) {
    return LeaveStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => LeaveStatus.PENDING,
    );
  }
}

// ==============================
// Leave Request DTO
// ==============================
class LeaveRequestDTO {
  String reason;
  DateTime startDate;
  DateTime endDate;

  LeaveRequestDTO({
    required this.reason,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "reason": reason,
      "startDate": startDate.toIso8601String().split('T')[0],
      "endDate": endDate.toIso8601String().split('T')[0],
    };
  }
}

// ==============================
// Leave Response DTO
// ==============================
class LeaveResponseDTO {
  int id;
  String reason;
  DateTime startDate;
  DateTime endDate;
  LeaveStatus status;
  int employeeId;
  String employeeName;

  LeaveResponseDTO({
    required this.id,
    required this.reason,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.employeeId,
    required this.employeeName,
  });

  factory LeaveResponseDTO.fromJson(Map<String, dynamic> json) {
    return LeaveResponseDTO(
      id: json['id'],
      reason: json['reason'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: LeaveStatus.fromString(json['status']),
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
    );
  }
}
