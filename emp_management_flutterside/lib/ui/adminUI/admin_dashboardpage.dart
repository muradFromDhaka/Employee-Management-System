import 'package:emp_management_flutterside/models/department.dart';
import 'package:emp_management_flutterside/models/employee.dart';
import 'package:emp_management_flutterside/services/attendanceService.dart';
import 'package:emp_management_flutterside/services/auth_service.dart';
import 'package:emp_management_flutterside/services/department_service.dart';
import 'package:emp_management_flutterside/services/employee_service.dart';
import 'package:emp_management_flutterside/services/leaveRequest_service.dart';
import 'package:emp_management_flutterside/services/payroll_service.dart';
import 'package:emp_management_flutterside/ui/adminUI/LeaveRequest/AdminLeaveRequestPage.dart';
import 'package:emp_management_flutterside/ui/adminUI/attendance/AdminAttendancePage.dart';
import 'package:emp_management_flutterside/ui/adminUI/department/department_list.dart';
import 'package:emp_management_flutterside/ui/adminUI/employee/list.dart';
import 'package:emp_management_flutterside/ui/adminUI/payroll/payroll_page.dart';
import 'package:emp_management_flutterside/ui/adminUI/roll_management_page.dart';
import 'package:emp_management_flutterside/ui/authUI/login_page.dart';
import 'package:flutter/material.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final AuthService _authService = AuthService();
  final DepartmentService _departmentService = DepartmentService();
  final EmployeeService _employeeService = EmployeeService();
  final AttendanceService _attendanceService = AttendanceService();
  final LeaveRequestService _leaveService = LeaveRequestService();
  final PayrollService _payrollService = PayrollService();

  List<EmployeeResponseDto>? _employees;
  List<DepartmentResponseDto>? _departments;

  int totalEmployee = 0;
  int totalDepartment = 0;
  int totalPresent = 0;
  int totalPendingLeaves = 0;

  bool isLoading = true;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
      _loadRecentActivities();
    });
  }

  Future<void> _loadDashboardData() async {
    try {
      final employees = await _employeeService.getEmployees();
      final departments = await _departmentService.getDepartments();
      final leaves = await _leaveService.getPendingLeaves();

      final attendance = await _attendanceService.getAll();

      final today = DateTime.now();

      final presentToday = attendance.where((a) {
        final attendanceDate = DateTime.parse(a.date);

        return attendanceDate.year == today.year &&
            attendanceDate.month == today.month &&
            attendanceDate.day == today.day &&
            a.status.toLowerCase() == "present";
      }).toList();

      setState(() {
        _employees = employees;
        _departments = departments;

        totalEmployee = employees.length;

        totalDepartment = departments.length;

        totalPresent = presentToday.length;

        totalPendingLeaves = leaves.length;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print(e);
    }
  }

  Future<void> _loadRecentActivities() async {
    try {
      // latest employees
      final employees = await _employeeService.getEmployees();

      // pending leaves
      final leaves = await _leaveService.getPendingLeaves();

      // payroll
      final payrolls = await _payrollService.getMonthlyPayroll("2026-05");

      List<ActivityModel> loadedActivities = [];

      // Employee Activity
      if (employees.isNotEmpty) {
        final employee = employees.last;

        loadedActivities.add(
          ActivityModel(
            icon: Icons.person_add,
            color: Colors.blue,
            title: "New Employee Joined",
            subtitle: "${employee.name} joined company",

            time: "Recently",
          ),
        );
      }

      // Leave Activity
      loadedActivities.add(
        ActivityModel(
          icon: Icons.event_busy,
          color: Colors.red,
          title: "Pending Leave Requests",
          subtitle: leaves.isEmpty
              ? "No pending leave requests"
              : "${leaves.first.employeeName} requested waiting approval",
          time: "Today",
        ),
      );

      // Payroll Activity
      loadedActivities.add(
        ActivityModel(
          icon: Icons.payments,
          color: Colors.green,
          title: "Payroll Generated",
          subtitle: payrolls.isEmpty
              ? "No payroll generated yet"
              : "${payrolls.length} payrolls generated",

          time: "This Month",
        ),
      );

      setState(() {
        activities = loadedActivities;
      });
    } catch (e) {
      print(e);
    }
  }

  void onLogout() async {
    await _authService.logout();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  final List<Map<String, dynamic>> quickActions = [
    {
      "title": "Employees",
      "icon": Icons.people_alt,
      "color": Colors.indigo,
      "page": const EmployeeList(),
    },
    {
      "title": "Attendance",
      "icon": Icons.access_time,
      "color": Colors.teal,
      "page": const AdminAttendancePage(),
    },
    {
      "title": "Payroll",
      "icon": Icons.payments,
      "color": Colors.deepOrange,
      "page": const PayrollPage(),
    },
    {
      "title": "Departments",
      "icon": Icons.business,
      "color": Colors.purple,
      "page": const DepartmentList(),
    },
    {
      "title": "LeaveRequest",
      "icon": Icons.attachment_outlined,
      "color": Colors.green,
      "page": const AdminLeaveRequestPage(),
    },
    {
      "title": "Role",
      "icon": Icons.roller_shades,
      "color": Colors.blueGrey,
      "page": const RoleManagementPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dashboardCards = [
      {
        "title": "Total Employees",
        "value": totalEmployee.toString(),
        "icon": Icons.people,
        "color": Colors.blue,
      },
      {
        "title": "Departments",
        "value": totalDepartment.toString(),
        "icon": Icons.apartment,
        "color": Colors.orange,
      },
      {
        "title": "Present Today",
        "value": totalPresent.toString(),
        "icon": Icons.check_circle,
        "color": Colors.green,
      },
      {
        "title": "Leave Requests",
        "value": totalPendingLeaves.toString(),
        "icon": Icons.event_busy,
        "color": Colors.red,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 155, 233, 243),
              child: IconButton(onPressed: onLogout, icon: Icon(Icons.logout)),
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= WELCOME CARD =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [Color(0xff4A67FF), Color(0xff6A5CFF)],
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back 👋",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Manage employees, attendance, payroll and reports easily.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= OVERVIEW =================
                    const Text(
                      "Overview",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dashboardCards.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        final item = dashboardCards[index];

                        return Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ICON
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: (item["color"] as Color).withOpacity(
                                    .12,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Icon(
                                    (item["icon"] as IconData),
                                    color: (item["color"] as Color),
                                    size: 30,
                                  ),
                                ),
                              ),

                              // TEXT
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["value"].toString(),
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item["title"].toString(),
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // ================= QUICK ACTIONS =================
                    const Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: quickActions.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: .95,
                          ),
                      itemBuilder: (context, index) {
                        final item = quickActions[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(20),

                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => item["page"] as Widget,
                              ),
                            );
                          },

                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),

                                  decoration: BoxDecoration(
                                    color: (item["color"] as Color).withOpacity(
                                      .12,
                                    ),

                                    shape: BoxShape.circle,
                                  ),

                                  child: Icon(
                                    item["icon"] as IconData,
                                    color: item["color"] as Color,
                                    size: 30,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  item["title"].toString(),

                                  textAlign: TextAlign.center,

                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // ================= RECENT ACTIVITY =================
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: activities.length,

                      itemBuilder: (context, index) {
                        final activity = activities[index];

                        return _activityCard(
                          icon: activity.icon,
                          iconColor: activity.color,
                          title: activity.title,
                          subtitle: activity.subtitle,
                          time: activity.time,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Employees"),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Departments",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  // ================= ACTIVITY CARD =================
  Widget _activityCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),

          Text(
            time,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// =============================================================================

class ActivityModel {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;

  ActivityModel({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

List<ActivityModel> activities = [];
