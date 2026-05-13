class PayrollRequestDto {
  final double basicSalary;
  final double bonus;
  final double deduction;
  final String month; // YearMonth → send as "YYYY-MM"
  final int employeeId;

  PayrollRequestDto({
    required this.basicSalary,
    required this.bonus,
    required this.deduction,
    required this.month,
    required this.employeeId,
  });

  Map<String, dynamic> toJson() {
    return {
      "basicSalary": basicSalary,
      "bonus": bonus,
      "deduction": deduction,
      "month": month,
      "employeeId": employeeId,
    };
  }
}

// ====================================================

class PayrollResponseDto {
  final int id;

  final double basicSalary;
  final double bonus;
  final double deduction;
  final double finalSalary;

  final String month; // YearMonth → "YYYY-MM"

  final int employeeId;
  final String employeeName;

  PayrollResponseDto({
    required this.id,
    required this.basicSalary,
    required this.bonus,
    required this.deduction,
    required this.finalSalary,
    required this.month,
    required this.employeeId,
    required this.employeeName,
  });

factory PayrollResponseDto.fromJson(Map<String, dynamic> json) {
  return PayrollResponseDto(
    id: (json["id"] ?? 0) as int,
    basicSalary: (json["basicSalary"] ?? 0).toDouble(),
    bonus: (json["bonus"] ?? 0).toDouble(),
    deduction: (json["deduction"] ?? 0).toDouble(),
    finalSalary: (json["finalSalary"] ?? 0).toDouble(),
    month: json["month"]?.toString() ?? "",
    employeeId: (json["employeeId"] ?? 0) as int,
    employeeName: json["employeeName"]?.toString() ?? "",
  );
}
}

String formatYearMonth(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}";
}