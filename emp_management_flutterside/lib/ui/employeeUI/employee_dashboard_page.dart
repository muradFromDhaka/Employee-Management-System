import 'package:emp_management_flutterside/models/attendance.dart';
import 'package:emp_management_flutterside/models/auth/user.dart';
import 'package:emp_management_flutterside/models/employee.dart';
import 'package:emp_management_flutterside/models/leaveRequest.dart';
import 'package:emp_management_flutterside/services/admin_service.dart';
import 'package:emp_management_flutterside/services/attendanceService.dart';
import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:emp_management_flutterside/services/employee_service.dart';
import 'package:emp_management_flutterside/services/leaveRequest_service.dart';
import 'package:emp_management_flutterside/ui/authUI/login_page.dart';
import 'package:emp_management_flutterside/ui/employeeUI/attendance/attendanceDashboard.dart';
import 'package:emp_management_flutterside/ui/employeeUI/leave_request/add.dart';
import 'package:emp_management_flutterside/ui/employeeUI/leave_request/list.dart';
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
  final __leaveRequestService = LeaveRequestService();
  final _employeeService = EmployeeService();
  final AttendanceService _attendanceService = AttendanceService();

  AttendanceResponse? todayAttendance;

  EmployeeResponseDto? _employee;
  int? _employeeId;
  int totalLeaves = 0;
  int approvedLeaves = 0;
  int pendingLeaves = 0;
  int rejectedLeaves = 0;
  int cancelledLeaves = 0;

  User? _currentUser;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentUser();
    });
  }

  Future<void> _loadCurrentUser() async {
    // await Future.delayed(const Duration(milliseconds: 500));
    try {
      print("🔥 LOAD STARTED");
      final jwtUser = await _authService.getCurrentUser2();
      final user = await _adminService.getUserByUsername(jwtUser!.userName);
      _employee = await _employeeService.getEmployeeByUsername(
        jwtUser.userName,
      );
      print("STEP 1: API CALL START");
      final list = await _attendanceService.getMyAttendance();
      print("STEP 2: LIST SIZE = ${list.length}");
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final found = list.where((e) => e.date == today).toList();

      _employeeId = _employee?.id ?? 0;
      final results = await Future.wait([
        __leaveRequestService.countLeavesByEmployeeIdAndStatus(
          _employeeId!,
          null,
        ),
        __leaveRequestService.countLeavesByEmployeeIdAndStatus(
          _employeeId!,
          LeaveStatus.APPROVED,
        ),
        __leaveRequestService.countLeavesByEmployeeIdAndStatus(
          _employeeId!,
          LeaveStatus.PENDING,
        ),
        __leaveRequestService.countLeavesByEmployeeIdAndStatus(
          _employeeId!,
          LeaveStatus.REJECTED,
        ),
        __leaveRequestService.countLeavesByEmployeeIdAndStatus(
          _employeeId!,
          LeaveStatus.CANCELLED,
        ),
      ]);

      setState(() {
        _currentUser = user;
        todayAttendance = found.isNotEmpty ? found.first : null;

        totalLeaves = results[0];
        approvedLeaves = results[1];
        pendingLeaves = results[2];
        rejectedLeaves = results[3];
        cancelledLeaves = results[4];
      });

      print("TODAY: $today");
      for (var e in list) {
        print("DB DATE: ${e.date}");
      }
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
        title: const Text(
          "Employee Dashboard",
          style: TextStyle(
            color: Color.fromARGB(255, 124, 241, 236),
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 20,
        // centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 143, 27, 238),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.pink,
              fontWeight: FontWeight.bold,
            ),
            onPressed: () {
              _onLogout();
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 222, 220, 247),
      body: RefreshIndicator(
        onRefresh: _loadCurrentUser,
        child: SingleChildScrollView(
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
                      color: Color.fromARGB(255, 154, 104, 235),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 60, 1, 224),
                ),
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
                      ).then((_) {
                        _loadCurrentUser();
                      });
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AttendanceDashboard(),
                        ),
                      );
                    },
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 60, 1, 224),
                ),
              ),

              const SizedBox(height: 10),

              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          "Total Leaves",
                          totalLeaves.toString(),
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                          "Approved",
                          approvedLeaves.toString(),
                          Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          "Pending",
                          pendingLeaves.toString(),
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                          "Rejected",
                          rejectedLeaves.toString(),
                          Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          "Cancelled",
                          cancelledLeaves.toString(),
                          Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ======================
              // RECENT ACTIVITY
              // ======================
              const Text(
                "Recent Activity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 60, 1, 224),
                ),
              ),

              const SizedBox(height: 10),

              _buildActivityTile(
                "Leave Request Submitted",
                pendingLeaves.toString(),
                Colors.orange,
              ),
              _buildActivityTile(
                "Leave Approved",
                approvedLeaves.toString(),
                Colors.green,
              ),
              // _buildActivityTile("Attendance Marked", "Today", Colors.blue),
              _buildActivityTile(
                "Today's Attendance",
                todayAttendance?.status ?? "Not Marked",
                Colors.blue,
              ),
            ],
          ),
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
