import 'dart:convert';
import 'package:emp_management_flutterside/models/employee.dart';
import 'package:emp_management_flutterside/services/api-config.dart';
import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:http/http.dart' as http;

class EmployeeService {
  final _authService = AuthService();
  String get baseUrl => "${ApiConfig.baseURL}/employees";

  Future<List<EmployeeResponseDto>> getEmployees() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => EmployeeResponseDto.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load employees");
    }
  }

  Future<EmployeeResponseDto> getEmployeeById(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$id"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      return EmployeeResponseDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load employee");
    }
  }

  Future<void> createEmployee(EmployeeRequestDto request) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _authService.headers(auth: true),
      body: jsonEncode(request.toJson()),
    );
    print(
      "employee from response:-----------------------------------${response.body}",
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create employee");
    }
  }

  Future<void> updateEmployee(int id, EmployeeRequestDto request) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: await _authService.headers(auth: true),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update employee");
    }
  }

  Future<void> deleteEmployee(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to delete employee");
    }
  }

  Future<List<EmployeeResponseDto>> searchByEmployeeName(String name) async {
    final response = await http.get(
      Uri.parse("$baseUrl/search?name=$name"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => EmployeeResponseDto.fromJson(e)).toList();
    } else {
      throw Exception("Failed to search employees");
    }
  }

  Future<List<EmployeeResponseDto>> getByDepartment(int departmentId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/department/$departmentId"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => EmployeeResponseDto.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load employees by department");
    }
  }

  Future<List<EmployeeResponseDto>> getByRole(String roleName) async {
    final response = await http.get(
      Uri.parse("$baseUrl/role?roleName=$roleName"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => EmployeeResponseDto.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load employees by role");
    }
  }

  Future<void> deactivateEmployee(int id) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/$id/deactivate"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to deactivate employee");
    }
  }

  Future<EmployeeResponseDto> updatePhone(int id, String phone) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/$id/phone?phone=$phone"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      return EmployeeResponseDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update phone");
    }
  }

  Future<int> getTotalEmployees() async {
    final response = await http.get(
      Uri.parse("$baseUrl/count"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception("Failed to get employee count");
    }
  }

  Future<bool> existsByEmail(String email) async {
    final response = await http.get(
      Uri.parse("$baseUrl/exists?email=$email"),
      headers: await _authService.headers(auth: true),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to check email");
    }
  }
}
