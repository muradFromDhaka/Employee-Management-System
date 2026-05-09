import 'package:emp_management_flutterside/models/leaveRequest.dart';
import 'package:emp_management_flutterside/services/leaveRequest_service.dart';
import 'package:emp_management_flutterside/ui/employeeUI/leave_request.dart/add.dart';
import 'package:flutter/material.dart';

class LeaveRequestList extends StatefulWidget {
  const LeaveRequestList({super.key});

  @override
  State<LeaveRequestList> createState() => _LeaveRequestListState();
}

class _LeaveRequestListState extends State<LeaveRequestList> {
  bool isLoading = true;
  final _leaveRequestService = LeaveRequestService();

  List<LeaveResponseDTO> leaves = [];
  // List<dynamic> leaves = [];

  @override
  void initState() {
    super.initState();
    loadLeaves();
  }

  void loadLeaves() async {
    try {
      final data = await _leaveRequestService.getMyLeaves();

      setState(() {
        leaves = data;
      });

      isLoading = false;
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Color statusColor(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.APPROVED:
        return Colors.green;

      case LeaveStatus.REJECTED:
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Leave Requests",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        titleSpacing: 0,
        backgroundColor: const Color.fromARGB(255, 135, 192, 238),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeaveRequestForm()),
              );
            },
            icon: Row(
              children: const [
                Icon(Icons.add),
                SizedBox(width: 4),
                Text(
                  "Add",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : leaves.isEmpty
          ? const Center(child: Text("No leave requests found"))
          : ListView.builder(
              itemCount: leaves.length,
              itemBuilder: (context, index) {
                final leave = leaves[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Container(
                    height: 120,
                    width: 120,
                    child: ListTile(
                      title: Text(
                        "Reason: ${leave.reason}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 78, 1, 49),
                        ),
                      ),
                      subtitle: Text(
                        "From: ${leave.startDate.toString().split(' ')[0]} ;"
                        "   To: ${leave.endDate.toString().split(' ')[0]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: statusColor(leave.status),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          leave.status.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
