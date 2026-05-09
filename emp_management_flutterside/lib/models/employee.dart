class EmployeeRequestDto {
  final String name;
  final String email;
  final String phone;
  final String address;
  final double basicSalary;
  final int departmentId;
  final String roleName;
  final String userName;

  EmployeeRequestDto({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.basicSalary,
    required this.departmentId,
    required this.roleName,
    required this.userName,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "basicSalary": basicSalary,
      "departmentId": departmentId,
      "roleName": roleName,
      "userName": userName,
    };
  }
}
// ========================================================

class EmployeeResponseDto {
  final int id;

  final String name;
  final String email;
  final String phone;
  final String address;

  final double basicSalary;
  final DateTime? joiningDate;
  final bool isActive;

  final int departmentId;
  final String departmentName;

  final String roleName;
   final String userName;

  EmployeeResponseDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.basicSalary,
    required this.joiningDate,
    required this.isActive,
    required this.departmentId,
    required this.departmentName,
    required this.roleName,
    required this.userName,
  });

  factory EmployeeResponseDto.fromJson(Map<String, dynamic> json) {
    return EmployeeResponseDto(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      phone: json["phone"] ?? '',
      address: json["address"] ?? '',

      basicSalary: (json["basicSalary"] as num).toDouble(),

      joiningDate: json["joiningDate"] != null
          ? DateTime.parse(json["joiningDate"])
          : null,

      isActive: json["active"] ?? false,

      departmentId: json["departmentId"] ?? 0,
      departmentName: json["departmentName"] ?? '',

      roleName: json["roleName"] ?? '',
      userName: json["userName"] ?? '',
    );
  }
}