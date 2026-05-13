// import 'package:emp_management_flutterside/services/auth_service.dart';
// import 'package:emp_management_flutterside/ui/adminUI/admin_dashboard.dart';
// import 'package:emp_management_flutterside/ui/authUI/login_page.dart';
// import 'package:emp_management_flutterside/ui/employeeUI/employee_dashboard_page.dart';
// import 'package:emp_management_flutterside/ui/managerUI/manager_dashboard.dart';
// import 'package:emp_management_flutterside/ui/publicUI/publicPage.dart';
// import 'package:flutter/material.dart';

// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   final AuthService _authService = AuthService();

//   @override
//   void initState() {
//     super.initState();
//     _startSplash();
//   }

//   void _startSplash() async {
//     // Splash delay
//     await Future.delayed(const Duration(seconds: 3));

//     final token = await _authService.getToken();

//     if (!mounted) return;

//     final results = await Future.wait([
//       _authService.hasRole('ROLE_ADMIN'),
//       _authService.hasRole('ROLE_MANAGER'),
//       _authService.hasRole('ROLE_EMPLOYEE'),
//       _authService.hasRole('ROLE_USER'),
//     ]);

//     if (token != null && token.isNotEmpty) {
//       final isAdmin = await _authService.hasRole('ROLE_ADMIN');
//       final isManager = await _authService.hasRole('ROLE_MANAGER');
//       final isEmployee = await _authService.hasRole('ROLE_EMPLOYEE');
//       final isUser = await _authService.hasRole('ROLE_USER');

//       if (isAdmin) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
//         );
//       } else if (isManager) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const ManagerDashboardPage()),
//         );
//       } else if (isEmployee) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const EmployeeDashboardPage()),
//         );
//       } else if (isUser) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const PublicPage()),
//         );
//       } else {
//         // কোন role assign করা নেই
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("No role assigned!")));
//       }
//     } else {
//       // token নেই → public view
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // change if needed
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // App Logo
//             ClipOval(
//               child: Image.asset(
//                 'assets/companyLOGO.jpg',
//                 width: 300,
//                 height: 300,
//                 fit: BoxFit.cover,
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Loader
//             const CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ===============================================================



import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:emp_management_flutterside/ui/adminUI/admin_dashboardpage.dart';
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

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  String statusText = "Initializing...";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _bootApp();
  }

  Future<void> _bootApp() async {
    try {
      setState(() => statusText = "Checking session...");

      await Future.delayed(const Duration(seconds: 5));

      final token = await _authService.getToken();

      if (!mounted) return;

      if (token == null || token.isEmpty) {
        _goTo(const LoginPage());
        return;
      }

      setState(() => statusText = "Validating user...");

      final results = await Future.wait([
        _authService.hasRole('ROLE_ADMIN'),
        _authService.hasRole('ROLE_MANAGER'),
        _authService.hasRole('ROLE_EMPLOYEE'),
        _authService.hasRole('ROLE_USER'),
      ]);

      final isAdmin = results[0];
      final isManager = results[1];
      final isEmployee = results[2];
      final isUser = results[3];

      setState(() => statusText = "Preparing dashboard...");

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      if (isAdmin) {
        _goTo(const AdminDashboardPage());
      } else if (isManager) {
        _goTo(const ManagerDashboardPage());
      } else if (isEmployee) {
        _goTo(const EmployeeDashboardPage());
      } else if (isUser) {
        _goTo(const PublicPage());
      } else {
        _goTo(const LoginPage());
      }
    } catch (e) {
      _goTo(const LoginPage());
    }
  }

  void _goTo(Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            colors: [Color.fromARGB(255, 125, 161, 233), Color.fromARGB(255, 62, 91, 139)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              ClipOval(
                child: Image.asset(
                  'assets/companyLOGO.jpg',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "EMP Management System",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const CircularProgressIndicator(color: Colors.white),

              const SizedBox(height: 20),

              Text(
                statusText,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
