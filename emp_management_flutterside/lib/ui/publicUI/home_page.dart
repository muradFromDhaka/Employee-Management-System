import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:emp_management_flutterside/ui/adminUI/admin_dashboard.dart';
import 'package:emp_management_flutterside/ui/authUI/login_page.dart';
import 'package:emp_management_flutterside/ui/managerUI/manager_dashboard.dart';
import 'package:emp_management_flutterside/ui/publicUI/publicPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
 const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authservice = AuthService();
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                final isAdmin = await authservice.hasRole('ROLE_ADMIN');
                final isManager = await authservice.hasRole('ROLE_MANAGER');
                final isEmployee = await authservice.hasRole('ROLE_EMPLOYEE');
                if (isAdmin) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminDashboardPage(),
                    ),
                  );
                } else if (isManager) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManagerDashboardPage(),
                    ),
                  );
                } else if (isEmployee) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PublicPage(),
                    ),
                  );
                }else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No role assigned!")),
                  );
                }
              },
              child: const Text("Go to Dashboard"),
            ),

            const SizedBox(height: 30),

            TextButton(
              onPressed: () async {
                try {
                  await authservice.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                } catch (e) {
                  print("Logout error: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logout failed!")),
                  );
                }
              },
              child: const Text("Logout"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PublicPage()),
                );
              },
              child: const Text("Public Page"),
            ),
          ],
        ),
      ),
    );
  }
}
