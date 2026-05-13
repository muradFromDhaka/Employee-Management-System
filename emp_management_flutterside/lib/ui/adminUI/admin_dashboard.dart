
// import 'package:flutter/material.dart';
// import 'package:emp_management_flutterside/services/auth_service.dart';
// import 'package:emp_management_flutterside/ui/adminUI/common_widget.dart';
// import 'package:emp_management_flutterside/ui/adminUI/department/department_list.dart';
// import 'package:emp_management_flutterside/ui/adminUI/employee/list.dart';
// import 'package:emp_management_flutterside/ui/adminUI/payroll/payroll_page.dart';
// import 'package:emp_management_flutterside/ui/adminUI/roll_management_page.dart';
// import 'package:emp_management_flutterside/ui/authUI/login_page.dart';

// class AdminDashboardPage extends StatefulWidget {
//   const AdminDashboardPage({super.key});

//   @override
//   State<AdminDashboardPage> createState() => _AdminDashboardPageState();
// }

// class _AdminDashboardPageState extends State<AdminDashboardPage> {
//   int selectedIndex = 0;
//   final _authService = AuthService();

//   final pages = const [
//     EmployeeList(),
//     DepartmentList(),
//     PayrollPage(),
//     RoleManagementPage(),
//   ];

//   final titles = const [
//     "Employees",
//     "Departments",
//     "Payroll",
//     "Role Management"
//   ];

//   void onLogout() async {
//     await _authService.logout();
//     if (!mounted) return;

//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginPage()),
//       (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff5f6fa),

//       appBar: CommonAdminAppBar(
//         title: titles[selectedIndex],
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none),
//             onPressed: () {},
//           ),
//           const SizedBox(width: 8),
//           const CircleAvatar(
//             radius: 16,
//             backgroundColor: Colors.white,
//             child: Icon(Icons.admin_panel_settings, size: 18),
//           ),
//           const SizedBox(width: 12),
//         ],
//       ),

//       drawer: CommonAdminDrawer(
//         selectedIndex: selectedIndex,
//         isDarkMode: false,
//         userName: "Super Admin",
//         userEmail: "admin@email.com",
//         onItemSelected: (index) {
//           setState(() => selectedIndex = index);
//         },
//         onLogout: onLogout,
//       ),

//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         child: pages[selectedIndex],
//       ),
//     );
//   }
// }