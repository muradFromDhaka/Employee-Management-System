import 'package:emp_management_flutterside/models/attendance.dart';
import 'package:emp_management_flutterside/services/attendanceService.dart';
import 'package:flutter/material.dart';

class AdminAttendancePage extends StatefulWidget {
  const AdminAttendancePage({super.key});

  @override
  State<AdminAttendancePage> createState() =>
      _AdminAttendancePageState();
}

class _AdminAttendancePageState
    extends State<AdminAttendancePage> {

  final AttendanceService _service =
      AttendanceService();

  List<AttendanceResponse> attendances = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  // ================= LOAD DATA =================
  Future<void> loadAttendance() async {
    try {
      final data = await _service.getAll();

      setState(() {
        attendances = data;
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // ================= DELETE =================
  Future<void> deleteAttendance(int id) async {
    try {
      await _service.deleteAttendance(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Deleted Successfully"),
        ),
      );

      loadAttendance();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // ================= STATUS COLOR =================
  Color getColor(String status) {
    switch (status.toLowerCase()) {
      case "present":
        return Colors.green;
      case "absent":
        return Colors.red;
      case "late":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "Attendance (Admin)",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : attendances.isEmpty
              ? const Center(
                  child: Text("No Attendance Found"),
                )

              : RefreshIndicator(
                  onRefresh: loadAttendance,

                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),

                    itemCount: attendances.length,

                    itemBuilder: (context, index) {

                      final item = attendances[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(18),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.05),

                              blurRadius: 10,
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            // ================= HEADER =================
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                              children: [

                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    Text(
                                      item.employeeName,

                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    Text(
                                      "ID: ${item.employeeId}",

                                      style: TextStyle(
                                        color:
                                            Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),

                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),

                                  decoration: BoxDecoration(
                                    color: getColor(
                                      item.status,
                                    ).withOpacity(0.15),

                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),

                                  child: Text(
                                    item.status,

                                    style: TextStyle(
                                      color: getColor(
                                        item.status,
                                      ),

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // ================= DATE =================
                            Text(
                              "Date: ${item.date}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // ================= TIME =================
                            Text(
                              "Check In: ${item.checkIn ?? '-'}",
                            ),

                            Text(
                              "Check Out: ${item.checkOut ?? '-'}",
                            ),

                            Text(
                              "Working Hours: ${item.workingHours ?? '-'}",
                            ),

                            const SizedBox(height: 12),

                            // ================= DELETE BUTTON =================
                            Align(
                              alignment: Alignment.centerRight,

                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),

                                onPressed: () {
                                  deleteAttendance(item.id);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}