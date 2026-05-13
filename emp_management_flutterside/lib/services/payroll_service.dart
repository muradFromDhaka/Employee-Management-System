import 'dart:convert';

import 'package:emp_management_flutterside/models/payroll.dart';
import 'package:emp_management_flutterside/services/api-config.dart';
import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:http/http.dart' as http;

class PayrollService {
  final AuthService _authService = AuthService();

  String get _baseUrl => "${ApiConfig.baseURL}/payrolls";

  // =========================
  // 1. GENERATE PAYROLL
  // POST /api/payrolls
  // =========================
  Future<PayrollResponseDto> generatePayroll({
    required int employeeId,
    required String month, // format => 2026-05
  }) async {
    final response = await http.post(
      Uri.parse(
        "$_baseUrl?employeeId=$employeeId&month=$month",
      ),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return PayrollResponseDto.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Failed to generate payroll: ${response.body}",
    );
  }

  // =========================
  // 2. GET PAYROLL BY ID
  // GET /api/payrolls/{id}
  // =========================
  Future<PayrollResponseDto> getPayrollById(int id) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/$id"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      return PayrollResponseDto.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Failed to load payroll",
    );
  }

  // =========================
  // 3. GET EMPLOYEE PAYROLL HISTORY
  // GET /api/payrolls/employee/{employeeId}
  // =========================
  Future<List<PayrollResponseDto>> getPayrollByEmployee(
    int employeeId,
  ) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/employee/$employeeId"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => PayrollResponseDto.fromJson(e))
          .toList();
    }

    throw Exception(
      "Failed to load payroll history",
    );
  }

  // =========================
  // 4. MONTHLY PAYROLL REPORT
  // GET /api/payrolls/monthly
  // =========================
  Future<List<PayrollResponseDto>> getMonthlyPayroll(
    String month,
  ) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/monthly?month=$month"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => PayrollResponseDto.fromJson(e))
          .toList();
    }

    throw Exception(
      "Failed to load monthly payroll",
    );
  }

  // =========================
  // 5. TOTAL SALARY EXPENSE
  // GET /api/payrolls/total-expense
  // =========================
  Future<double> getTotalExpense(String month) async {
    final response = await http.get(
      Uri.parse(
        "$_baseUrl/total-expense?month=$month",
      ),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as num)
          .toDouble();
    }

    throw Exception(
      "Failed to load total expense",
    );
  }

  // =========================
  // 6. GET LATEST PAYROLL
  // GET /api/payrolls/employee/{employeeId}/latest
  // =========================
  Future<PayrollResponseDto> getLatestPayroll(
    int employeeId,
  ) async {
    final response = await http.get(
      Uri.parse(
        "$_baseUrl/employee/$employeeId/latest",
      ),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      return PayrollResponseDto.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Failed to load latest payroll",
    );
  }
}