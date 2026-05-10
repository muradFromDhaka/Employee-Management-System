class AttendanceRequest {
  final String date;
  final String status;
  final String? checkIn;
  final String? checkOut;
  final int employeeId;

  AttendanceRequest({
    required this.date,
    required this.status,
    this.checkIn,
    this.checkOut,
    required this.employeeId,
  });

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "status": status,
      "checkIn": checkIn,
      "checkOut": checkOut,
      "employeeId": employeeId,
    };
  }
}

// ==================================================
class AttendanceResponse {
  final int id;
  final String date;
  final String status;
  final String? checkIn;
  final String? checkOut;
    final String? workingHours;
  final int employeeId;
  final String employeeName;

  AttendanceResponse({
    required this.id,
    required this.date,
    required this.status,
    this.checkIn,
    this.checkOut,
        this.workingHours,
    required this.employeeId,
    required this.employeeName,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      employeeId: (json['employeeId']) as int,
      employeeName: (json['employeeName'] ?? 0).toString(),
      workingHours: json['workingHours'] ?? ''
    );
  }
}
