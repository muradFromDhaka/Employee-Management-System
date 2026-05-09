import 'dart:convert';

import 'package:emp_management_flutterside/models/department.dart';
import 'package:emp_management_flutterside/services/api-config.dart';
import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:http/http.dart' as http;

class DepartmentService {
  Uri uri = Uri.parse('${ApiConfig.baseURL}/departments');
  final _authService = AuthService();

  Future<List<DepartmentResponseDto>> getDepartments() async {
    try {
      final response = await http.get(
        uri,
        headers: await _authService.headers(auth: true),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => DepartmentResponseDto.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      throw Exception('Error fetching departments: $e');
    }
  }

  Future<DepartmentResponseDto> getDepartmentById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseURL}/departments/$id'),
        headers: await _authService.headers(auth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DepartmentResponseDto.fromJson(data);
      } else {
        throw Exception('Failed to load department');
      }
    } catch (e) {
      throw Exception('Error fetching department: $e');
    }
  }

  Future<void> createDepartment(DepartmentRequestDto request) async {
    try {
      final response = await http.post(
        uri,
        headers: await _authService.headers(auth: true),
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create department');
      }
    } catch (e) {
      throw Exception('Error creating department: $e');
    }
  }

  Future<void> updateDepartment(int id, DepartmentRequestDto request) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseURL}/departments/$id'),
        headers: await _authService.headers(auth: true),
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update department');
      }
    } catch (e) {
      throw Exception('Error updating department: $e');
    }
  }

  Future<void> deleteDepartment(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseURL}/departments/$id'),
        headers: await _authService.headers(auth: true),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete department');
      }
    } catch (e) {
      throw Exception('Error deleting department: $e');
    }
  }

  Future<DepartmentResponseDto> getDepartmentWithEmployees(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseURL}/departments/$id/employees'),
        headers: await _authService.headers(auth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DepartmentResponseDto.fromJson(data);
      } else {
        throw Exception('Failed to load department with employees');
      }
    } catch (e) {
      throw Exception('Error fetching department with employees: $e');
    }
  }

  Future<int> countEmployeesInDepartment(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseURL}/departments/$id/employee-count'),
        headers: await _authService.headers(auth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data is int ? data : int.parse(data.toString());
      } else {
        throw Exception('Failed to count employees in department');
      }
    } catch (e) {
      throw Exception('Error counting employees in department: $e');
    }
  }
}
