import 'package:flutter/material.dart';
import 'package:emp_management_flutterside/models/attendance.dart';
import 'package:emp_management_flutterside/services/attendanceService.dart';

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  final AttendanceService _service = AttendanceService();

  AttendanceResponse? todayAttendance;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadToday();
    });
  }

  // =========================
  // SAFE LOADING STATE
  // =========================
  void _setLoading(bool value) {
    if (!mounted) return;
    setState(() => isLoading = value);
  }

  // =========================
  // LOAD TODAY ATTENDANCE (CLEAN)
  // =========================
  Future<void> _loadToday() async {
    _setLoading(true);

    try {
      final list = await _service.getMyAttendance();

      final today = DateTime.now().toIso8601String().substring(0, 10);

      final found = list.where((e) => e.date == today).toList();

      if (!mounted) return;
      setState(() {
        todayAttendance = found.isNotEmpty ? found.first : null;
      });
    } catch (e) {
      _showError(e.toString());
    }

    _setLoading(false);
  }

  // =========================
  // CHECK IN
  // =========================
  Future<void> _checkIn() async {
    _setLoading(true);

    try {
      final res = await _service.checkIn();

      if (!mounted) return;
      setState(() {
        todayAttendance = res;
      });

      _showMessage("Checked in successfully");
    } catch (e) {
      _showError(e.toString());
    }

    _setLoading(false);
  }

  // =========================
  // CHECK OUT
  // =========================
  Future<void> _checkOut() async {
    _setLoading(true);

    try {
      final res = await _service.checkOut();

      if (!mounted) return;
      setState(() {
        todayAttendance = res;
      });

      _showMessage("Checked out successfully");
    } catch (e) {
      _showError(e.toString());
    }

    _setLoading(false);
  }

  // =========================
  // STATUS COLOR
  // =========================
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "present":
        return Colors.green;
      case "late":
        return Colors.orange;
      case "absent":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  // =========================
  // SNACKBAR HELPERS
  // =========================
  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(msg)));
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    final isCheckedIn = todayAttendance?.checkIn != null;
    final isCheckedOut = todayAttendance?.checkOut != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance Dashboard",
          style: TextStyle(
            color: Color.fromARGB(255, 124, 241, 236),
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 5,
        backgroundColor: const Color.fromARGB(255, 149, 39, 240),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 243, 188, 229),
      body: RefreshIndicator(
        onRefresh: _loadToday,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // =========================
            // STATUS CARD
            // =========================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 10),

                  Text(
                    !isCheckedIn
                        ? "Ready for Attendance"
                        : isCheckedOut
                        ? "Completed Today"
                        : "Currently Working",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 34, 1, 88),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (todayAttendance != null) ...[
                    Text(
                      "Date: ${todayAttendance!.date}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 146, 33, 1),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(
                          todayAttendance!.status,
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        todayAttendance!.status.toUpperCase(),
                        style: TextStyle(
                          color: _statusColor(todayAttendance!.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Check In: ${formatTime(todayAttendance!.checkIn ?? '--')}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 88, 2, 187),
                      ),
                    ),
                    Text(
                      "Check Out: ${formatTime(todayAttendance!.checkOut ?? '--')}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 168, 5, 243),
                      ),
                    ),
                    Text(
                      "Working Hours: ${todayAttendance!.workingHours}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // CHECK IN BUTTON
            // =========================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 236, 114, 240),
                ),
                onPressed: (!isCheckedIn && !isLoading) ? _checkIn : null,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Check In"),
              ),
            ),

            const SizedBox(height: 10),

            // =========================
            // CHECK OUT BUTTON
            // =========================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (isCheckedIn && !isCheckedOut && !isLoading)
                    ? _checkOut
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 236, 114, 240),
                ),
                child: const Text("Check Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =======================================================================

  String formatTime(String? time) {
    if (time == null || time.isEmpty) return "--";

    try {
      // Case 1: full datetime (ISO format)
      if (time.contains("T")) {
        final dt = DateTime.parse(time);

        final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
        final ampm = dt.hour >= 12 ? "PM" : "AM";
        final minute = dt.minute.toString().padLeft(2, '0');

        return "$hour:$minute $ampm";
      }

      // Case 2: time only (15:11:14.655)
      final parts = time.split(":");

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      final ampm = hour >= 12 ? "PM" : "AM";
      hour = hour % 12 == 0 ? 12 : hour % 12;

      return "$hour:${minute.toString().padLeft(2, '0')} $ampm";
    } catch (e) {
      return "--";
    }
  }
}
