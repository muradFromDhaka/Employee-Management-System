import 'package:http/http.dart' as http;

import 'package:emp_management_flutterside/models/attendance.dart';
import 'package:emp_management_flutterside/services/api-config.dart';
import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:emp_management_flutterside/services/responseHandle.dart';

class AttendanceService {
  final String baseUrl = "${ApiConfig.baseURL}/attendances";
  final AuthService _authService = AuthService();

  // =========================
  // COMMON REQUEST HANDLER
  // =========================
  Future<dynamic> _get(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: await _authService.headers(auth: true),
    );
    return handleResponse(response);
  }

  Future<dynamic> _post(String url) async {
    final response = await http.post(
      Uri.parse(url),
      headers: await _authService.headers(auth: true),
    );
    return handleResponse(response);
  }

  Future<dynamic> _delete(String url) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: await _authService.headers(auth: true),
    );
    return handleResponse(response);
  }

  // =========================
  // CHECK-IN
  // =========================
  Future<AttendanceResponse> checkIn() async {
    try {
      final data = await _post("$baseUrl/check-in");
      return AttendanceResponse.fromJson(data);
    } catch (e) {
      throw Exception("Check-in failed: $e");
    }
  }

  // =========================
  // CHECK-OUT
  // =========================
  Future<AttendanceResponse> checkOut() async {
    try {
      final data = await _post("$baseUrl/check-out");
      return AttendanceResponse.fromJson(data);
    } catch (e) {
      throw Exception("Check-out failed: $e");
    }
  }

  // =========================
  // GET CURRENT EMPLOYEE ATTENDANCE
  // (matches backend: /employee)
  // =========================
  Future<List<AttendanceResponse>> getMyAttendance() async {
    try {
      final data = await _get("$baseUrl/employee");

      if (data is List) {
        return data.map((e) => AttendanceResponse.fromJson(e)).toList();
      }

      throw Exception("Invalid response format");
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // GET ALL (ADMIN)
  // =========================
  Future<List<AttendanceResponse>> getAll() async {
    final data = await _get(baseUrl);

    if (data is List) {
      return data.map((e) => AttendanceResponse.fromJson(e)).toList();
    }

    throw Exception("Invalid response format");
  }

  // =========================
  // GET BY ID (ADMIN)
  // =========================
  Future<AttendanceResponse> getById(int id) async {
    final data = await _get("$baseUrl/$id");
    return AttendanceResponse.fromJson(data);
  }

  // =========================
  // GET BY DATE (ADMIN)
  // =========================
  Future<List<AttendanceResponse>> getByDate(String date) async {
    final data = await _get("$baseUrl/selectedDate?date=$date");

    if (data is List) {
      return data.map((e) => AttendanceResponse.fromJson(e)).toList();
    }

    throw Exception("Invalid response format");
  }

  // =========================
  // DELETE (ADMIN)
  // =========================
  Future<void> deleteAttendance(int id) async {
    await _delete("$baseUrl/$id");
  }

  // =========================
  // COUNT PRESENT DAYS (SELF)
  // =========================
  Future<int> countPresentDays() async {
    final data = await _get("$baseUrl/count");

    if (data is int) return data;
    if (data is String) return int.parse(data);

    throw Exception("Invalid response format");
  }

  // =========================
  // MONTHLY REPORT (SELF)
  // =========================
  Future<List<AttendanceResponse>> getMonthlyAttendance(String month) async {
    final data = await _get("$baseUrl/monthly?month=$month");

    if (data is List) {
      return data.map((e) => AttendanceResponse.fromJson(e)).toList();
    }

    throw Exception("Invalid response format");
  }

  // =========================
  // CHECK OPEN ATTENDANCE (SELF)
  // =========================
  Future<bool> hasOpenAttendance() async {
    final data = await _get("$baseUrl/employees/open");

    if (data is bool) return data;

    throw Exception("Invalid response format");
  }
}