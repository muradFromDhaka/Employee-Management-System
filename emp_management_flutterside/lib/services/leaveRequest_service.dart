import 'dart:convert';

import 'package:emp_management_flutterside/models/leaveRequest.dart';
import 'package:emp_management_flutterside/services/api-config.dart';
import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:emp_management_flutterside/services/responseHandle.dart';
import 'package:http/http.dart' as http;

class LeaveRequestService {
  String get baseUrl => "${ApiConfig.baseURL}/leaves";
  final _authService = AuthService();

  Future<LeaveResponseDTO> applyLeave(LeaveRequestDTO leaveData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _authService.headers(auth: true),
      body: jsonEncode(leaveData.toJson()),
    );
    print("-------------------$response.statusCode");
    print("-------------------${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return LeaveResponseDTO.fromJson(data);
    }
    throw Exception("Failed to apply for leave");
  }

  Future<List<LeaveResponseDTO>> getAllLeaves() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await _authService.headers(auth: true),
    );

    final data = handleResponse(response);

    return (data as List).map((e) => LeaveResponseDTO.fromJson(e)).toList();
  }

  Future<List<LeaveResponseDTO>> getMyLeaves() async {
    final response = await http.get(
      Uri.parse("$baseUrl/my-leaves"),
      headers: await _authService.headers(auth: true),
    );

    return (handleResponse(response) as List)
        .map((e) => LeaveResponseDTO.fromJson(e))
        .toList();
  }

  Future<LeaveResponseDTO> getLeaveById(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$id"),
      headers: await _authService.headers(auth: true),
    );

    final data = handleResponse(response);
    return LeaveResponseDTO.fromJson(data as Map<String, dynamic>);
  }

  Future<List<LeaveResponseDTO>> getEmployeeLeaves(int employeeId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/employee/$employeeId"),
      headers: await _authService.headers(auth: true),
    );

    final data = handleResponse(response);
    return (data as List).map((e) => LeaveResponseDTO.fromJson(e)).toList();
  }

  Future<LeaveResponseDTO> approveLeave(int id) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id/approve"),
      headers: await _authService.headers(auth: true),
    );

    final data = handleResponse(response);
    return LeaveResponseDTO.fromJson(data as Map<String, dynamic>);
  }

  Future<LeaveResponseDTO> rejectLeave(int id) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id/reject"),
      headers: await _authService.headers(auth: true),
    );

    final data = handleResponse(response);
    return LeaveResponseDTO.fromJson(data as Map<String, dynamic>);
  }

  Future<List<LeaveResponseDTO>> getPendingLeaves() async {
    final response = await http.get(
      Uri.parse("$baseUrl/pending"),
      headers: await _authService.headers(auth: true),
    );

    final data = handleResponse(response);
    return (data as List).map((e) => LeaveResponseDTO.fromJson(e)).toList();
  }

  Future<List<LeaveResponseDTO>> getLeaveReport({
    required String from,
    required String to,
  }) async {
    final uri = Uri.parse("$baseUrl/report?from=$from&to=$to");

    final response = await http.get(
      uri,
      headers: await _authService.headers(auth: true),
    );

    final data = handleResponse(response);
    return (data as List).map((e) => LeaveResponseDTO.fromJson(e)).toList();
  }

  Future<int> countLeaves(int employeeId, String status) async {
    final uri = Uri.parse(
      "$baseUrl/count?employeeId=$employeeId&status=$status",
    );

    final response = await http.get(
      uri,
      headers: await _authService.headers(auth: true),
    );

    return handleResponse(response) as int;
  }

  Future<bool> deleteLeave(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: await _authService.headers(auth: true),
    );

    return response.statusCode == 204;
  }
}
