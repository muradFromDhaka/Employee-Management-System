import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:emp_management_flutterside/ui/adminUI/common_widget.dart';
import 'package:emp_management_flutterside/ui/adminUI/department/department_list.dart';
import 'package:emp_management_flutterside/ui/adminUI/employee/list.dart';
import 'package:emp_management_flutterside/ui/adminUI/roll_management_page.dart';
import 'package:emp_management_flutterside/ui/authUI/login_page.dart';
import 'package:flutter/material.dart';
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminDashboardPage> {
  int selectedIndex = 0;
  bool isDarkMode = false;
  final _authService = AuthService();

  final pages = [
    EmployeeList(),
    DepartmentList(),
    RoleManagementPage(),
  ];

  void onLogout() async {
    await _authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (Route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAdminAppBar(title: "Admin Panel"),
      drawer: CommonAdminDrawer(
        selectedIndex: selectedIndex,
        isDarkMode: isDarkMode,
        userName: "Super Admin",
        userEmail: "admin@email.com",
        onItemSelected: (index) {
          setState(() => selectedIndex = index);
        },
        onLogout: onLogout,
      ),
      body: pages[selectedIndex],
    );
  }
}
