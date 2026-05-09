import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:emp_management_flutterside/ui/adminUI/admin_dashboard.dart';
import 'package:emp_management_flutterside/ui/authUI/login_page.dart';
import 'package:emp_management_flutterside/ui/employeeUI/employee_dashboard_page.dart';
import 'package:emp_management_flutterside/ui/managerUI/manager_dashboard.dart';
import 'package:emp_management_flutterside/ui/publicUI/publicPage.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  void _startSplash() async {
    // Splash delay
    await Future.delayed(const Duration(seconds: 3));

    final token = await _authService.getToken();

    if (!mounted) return;
    // print("mounted: $mounted");



    if (token != null && token.isNotEmpty) {
      final isAdmin = await _authService.hasRole('ROLE_ADMIN');
      final   isManager = await _authService.hasRole('ROLE_MANAGER');
      final isEmployee = await _authService.hasRole('ROLE_EMPLOYEE');
      final isUser = await _authService.hasRole('ROLE_USER');

      if (isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
        );
      } else if (isManager) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ManagerDashboardPage()),
        );
      } else if (isEmployee) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeDashboardPage()),
        );
      } else if (isUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PublicPage()),
        );
      } else {
        // কোন role assign করা নেই
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No role assigned!")));
      }
    } else {
      // token নেই → public view
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // change if needed
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Logo
            ClipOval(
              child: Image.asset(
                'assets/companyLOGO.jpg',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // Loader
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}


