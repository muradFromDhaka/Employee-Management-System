import 'dart:convert';
import 'package:emp_management_flutterside/models/auth/role.dart';
import 'package:emp_management_flutterside/models/auth/user.dart';
import 'package:emp_management_flutterside/services/api-config.dart';
import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:emp_management_flutterside/services/responseHandle.dart';
import 'package:http/http.dart' as http;

class AdminService {
  final AuthService _authService = AuthService();

  String get _baseUrl => "${ApiConfig.baseURL}/admin";

  /* ================= GET ALL ROLES ================= */

  Future<List<Role>> getAllRoles() async {
    final res = await http.get(
      Uri.parse("$_baseUrl/roles"),
      headers: await _authService.headers(auth: true),
    );

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List)
          .map((e) => Role.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load roles");
  }

  Future<List<User>> getAllUsers() async {
    final res = await http.get(
      Uri.parse("${ApiConfig.baseURL}/users"),
      headers: await _authService.headers(auth: true),
    );

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List)
          .map((e) => User.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load users");
  }

  /* ================= CREATE ROLE ================= */

  Future<Map<String, dynamic>> createRole(
    String roleName,
    String description,
  ) async {
    final res = await http.post(
      Uri.parse("$_baseUrl/roles"),
      headers: await _authService.headers(auth: true),
      body: jsonEncode({"roleName": roleName, "description": description}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }

    throw Exception("Failed to create role");
  }

  /* ================= UPDATE USER ROLES ================= */

  Future<Map<String, dynamic>> updateUserRoles(
    String username,
    List<String> roles,
  ) async {
    final res = await http.put(
      Uri.parse("$_baseUrl/users/$username/roles"),
      headers: await _authService.headers(auth: true),
      body: jsonEncode({"roles": roles}),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    throw Exception("Failed to update user roles");
  }

  /* ================= GET USERS BY ROLE ================= */

  Future<List<dynamic>> getUsersByRole(String roleName) async {
    final res = await http.get(
      Uri.parse("$_baseUrl/roles/$roleName/users"),
      headers: await _authService.headers(auth: true),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    throw Exception("Failed to load users by role");
  }

  Future<User> getUserByUsername(String username) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseURL}/users/$username"),
      headers: await _authService.headers(auth: true),
    );

    final data = handleResponse(response);

    return User.fromJson(data as Map<String, dynamic>);
  }
}
