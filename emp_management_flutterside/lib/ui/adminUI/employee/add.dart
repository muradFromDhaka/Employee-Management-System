

import 'package:emp_management_flutterside/models/auth/role.dart';
import 'package:emp_management_flutterside/models/department.dart';
import 'package:flutter/material.dart';
import 'package:emp_management_flutterside/models/employee.dart';
import 'package:emp_management_flutterside/services/employee_service.dart';
import 'package:emp_management_flutterside/services/department_service.dart';
import 'package:emp_management_flutterside/services/admin_service.dart';

class EmployeeForm extends StatefulWidget {
  final EmployeeResponseDto? employee;

  const EmployeeForm({super.key, this.employee});

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  final EmployeeService _employeeService = EmployeeService();
  final DepartmentService _departmentService = DepartmentService();
  final AdminService _adminService = AdminService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _salaryController;

  int? selectedDepartmentId;
  String? selectedRole;
  String? selectedUserName;

  List<DepartmentResponseDto> departments = [];
  List<Role> roles = [];
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();

    final emp = widget.employee;

    _nameController = TextEditingController(text: emp?.name ?? "");
    _emailController = TextEditingController(text: emp?.email ?? "");
    _phoneController = TextEditingController(text: emp?.phone ?? "");
    _addressController = TextEditingController(text: emp?.address ?? "");
    _salaryController = TextEditingController(
      text: emp?.basicSalary.toString() ?? "",
    );

    selectedDepartmentId = emp?.departmentId;
    selectedRole = emp?.roleName;
    selectedUserName = emp?.userName;

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final deptData = await _departmentService.getDepartments();
      final roleData = await _adminService.getAllRoles();
      final userData = await _adminService.getAllUsers();

      setState(() {
        departments = deptData;
        roles = roleData;
        users = userData;
      });
    } catch (e) {
      debugPrint("Load error: $e");
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedUserName == null ||
        selectedRole == null ||
        selectedDepartmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final request = EmployeeRequestDto(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      basicSalary: double.tryParse(_salaryController.text) ?? 0,
      departmentId: selectedDepartmentId!,
      roleName: selectedRole!,
      userName: selectedUserName!,
    );

    try {
      if (widget.employee == null) {
        await _employeeService.createEmployee(request);
      } else {
        await _employeeService.updateEmployee(widget.employee!.id, request);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.employee != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Employee" : "Create Employee")),
      body: RefreshIndicator(
        onRefresh: ()async{
           await _loadData();
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              TextFormField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Basic Salary"),
              ),

              const SizedBox(height: 12),

              // USER DROPDOWN
              DropdownButtonFormField<String>(
                initialValue: selectedUserName,
                items: users.map<DropdownMenuItem<String>>((user) {
                  return DropdownMenuItem<String>(
                    value: user['userName'], // MUST MATCH BACKEND KEY
                    child: Text(user['userName'] ?? user['name'] ?? ""),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUserName = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "User",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // DEPARTMENT
              DropdownButtonFormField<int>(
                initialValue: selectedDepartmentId,
                items: departments.map<DropdownMenuItem<int>>((dept) {
                  return DropdownMenuItem<int>(
                    value: dept.id,
                    child: Text(dept.depName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartmentId = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // ROLE
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                items: roles.map<DropdownMenuItem<String>>((r) {
                  return DropdownMenuItem<String>(
                    value: r.roleName,
                    child: Text(r.roleName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Role",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submit,
                child: Text(isEdit ? "Update" : "Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
