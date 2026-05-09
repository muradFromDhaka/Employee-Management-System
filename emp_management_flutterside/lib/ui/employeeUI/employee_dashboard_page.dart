import 'package:emp_management_flutterside/models/auth/user.dart';
import 'package:emp_management_flutterside/services/admin_service.dart';
import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:emp_management_flutterside/ui/authUI/login_page.dart';
import 'package:emp_management_flutterside/ui/employeeUI/leave_request.dart/add.dart';
import 'package:emp_management_flutterside/ui/employeeUI/leave_request.dart/list.dart';
import 'package:flutter/material.dart';

class EmployeeDashboardPage extends StatefulWidget {
  const EmployeeDashboardPage({super.key});

  @override
  State<EmployeeDashboardPage> createState() => _EmployeeDashboardPageState();
}

class _EmployeeDashboardPageState extends State<EmployeeDashboardPage> {
  final String employeeName = "John Doe";
  final AuthService _authService = AuthService();
  final AdminService _adminService = AdminService();
  User? _currentUser;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    try {
      final userName = await _authService.getCurrentUser2();
      final user = await _adminService.getUserByUsername(userName!.userName);
      ;
      setState(() {
        _currentUser = user;
      });
    } catch (e) {
      print("Error loading current user: $e");
    }
  }

  void _onLogout() async {
    await _authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Dashboard", style: TextStyle(color: Color.fromARGB(255, 144, 4, 224)),),
        titleSpacing: 20,
        // centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 135, 192, 238),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _onLogout();
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Welcome,",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  "${_currentUser?.userFirstName ?? ''} ${_currentUser?.userLastName ?? ''} 👋",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ======================
            // QUICK ACTIONS
            // ======================
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildActionCard(
                  icon: Icons.event_available,
                  title: "Apply Leave",
                  color: Colors.blue,
                  onTap: () {
                    // Navigator.push to LeaveRequestForm
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaveRequestForm(),
                      ),
                    );
                  },
                ),

                _buildActionCard(
                  icon: Icons.list_alt,
                  title: "My Leaves",
                  color: Colors.orange,
                  onTap: () {
                    // Navigator.push to LeaveRequestList
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeaveRequestList(),
                      ),
                    );
                  },
                ),

                _buildActionCard(
                  icon: Icons.access_time,
                  title: "Attendance",
                  color: Colors.green,
                  onTap: () {},
                ),

                _buildActionCard(
                  icon: Icons.person,
                  title: "Profile",
                  color: Colors.purple,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ======================
            // STATS SECTION
            // ======================
            const Text(
              "My Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard("Total Leaves", "12", Colors.blue),
                ),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard("Approved", "8", Colors.green)),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(child: _buildStatCard("Pending", "3", Colors.orange)),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard("Rejected", "1", Colors.red)),
              ],
            ),

            const SizedBox(height: 25),

            // ======================
            // RECENT ACTIVITY
            // ======================
            const Text(
              "Recent Activity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            _buildActivityTile(
              "Leave Request Submitted",
              "Pending",
              Colors.orange,
            ),
            _buildActivityTile("Leave Approved", "Approved", Colors.green),
            _buildActivityTile("Attendance Marked", "Today", Colors.blue),
          ],
        ),
      ),
    );
  }

  // ======================
  // ACTION CARD
  // ======================
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  // ======================
  // STAT CARD
  // ======================
  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }

  // ======================
  // ACTIVITY TILE
  // ======================
  Widget _buildActivityTile(String title, String status, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.circle, color: color, size: 14),
        title: Text(title),
        trailing: Text(
          status,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
