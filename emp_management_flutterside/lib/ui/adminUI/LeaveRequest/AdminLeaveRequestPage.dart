import 'package:emp_management_flutterside/models/leaveRequest.dart';
import 'package:emp_management_flutterside/services/leaveRequest_service.dart';
import 'package:flutter/material.dart';

class AdminLeaveRequestPage extends StatefulWidget {
  const AdminLeaveRequestPage({super.key});

  @override
  State<AdminLeaveRequestPage> createState() =>
      _AdminLeaveRequestPageState();
}

class _AdminLeaveRequestPageState
    extends State<AdminLeaveRequestPage> {

  final LeaveRequestService _leaveService =
      LeaveRequestService();

  List<LeaveResponseDTO> leaves = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadLeaves();
  }

  // ================= LOAD LEAVES =================
  Future<void> loadLeaves() async {
    try {

      final data =
          await _leaveService.getAllLeaves();

      setState(() {
        leaves = data;
        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  // ================= APPROVE =================
  Future<void> approveLeave(int id) async {
    try {

      await _leaveService.approveLeave(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Leave Approved"),
        ),
      );

      loadLeaves();

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  // ================= REJECT =================
  Future<void> rejectLeave(int id) async {
    try {

      await _leaveService.rejectLeave(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Leave Rejected"),
        ),
      );

      loadLeaves();

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  // ================= STATUS COLOR =================
  Color getStatusColor(LeaveStatus status) {

    switch (status) {

      case LeaveStatus.APPROVED:
        return Colors.green;

      case LeaveStatus.REJECTED:
        return Colors.red;

      case LeaveStatus.PENDING:
        return Colors.orange;

      case LeaveStatus.CANCELLED:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text(
          "Leave Requests",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : leaves.isEmpty
              ? const Center(
                  child: Text(
                    "No Leave Requests Found",
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadLeaves,

                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),

                    itemCount: leaves.length,

                    itemBuilder: (context, index) {

                      final leave = leaves[index];

                      return Container(
                        margin:
                            const EdgeInsets.only(
                          bottom: 16,
                        ),

                        padding:
                            const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            22,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(.05),

                              blurRadius: 10,

                              offset:
                                  const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            // ================= HEADER =================
                            Row(
                              children: [

                                CircleAvatar(
                                  backgroundColor:
                                      Colors.indigo
                                          .withOpacity(.1),

                                  child: const Icon(
                                    Icons.person,
                                    color:
                                        Colors.indigo,
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      Text(
                                        leave
                                            .employeeName,

                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .bold,

                                          fontSize: 16,
                                        ),
                                      ),

                                      Text(
                                        "Employee ID: ${leave.employeeId}",

                                        style:
                                            TextStyle(
                                          color: Colors
                                              .grey
                                              .shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        getStatusColor(
                                          leave
                                              .status,
                                        ).withOpacity(
                                          .12,
                                        ),

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      30,
                                    ),
                                  ),

                                  child: Text(
                                    leave.status.name,

                                    style: TextStyle(
                                      color:
                                          getStatusColor(
                                            leave
                                                .status,
                                          ),

                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // ================= REASON =================
                            const Text(
                              "Reason",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              leave.reason,
                              style: TextStyle(
                                color:
                                    Colors.grey.shade700,
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ================= DATE =================
                            Row(
                              children: [

                                Expanded(
                                  child: Container(
                                    padding:
                                        const EdgeInsets
                                            .all(12),

                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .blue
                                          .withOpacity(
                                        .08,
                                      ),

                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        14,
                                      ),
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: [

                                        const Text(
                                          "Start Date",
                                          style:
                                              TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 6,
                                        ),

                                        Text(
                                          leave
                                              .startDate
                                              .toString()
                                              .split(
                                                " ",
                                              )[0],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Container(
                                    padding:
                                        const EdgeInsets
                                            .all(12),

                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .red
                                          .withOpacity(
                                        .08,
                                      ),

                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        14,
                                      ),
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: [

                                        const Text(
                                          "End Date",
                                          style:
                                              TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 6,
                                        ),

                                        Text(
                                          leave
                                              .endDate
                                              .toString()
                                              .split(
                                                " ",
                                              )[0],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // ================= ACTION BUTTONS =================
                            if (leave.status ==
                                LeaveStatus.PENDING)
                              Padding(
                                padding:
                                    const EdgeInsets.only(
                                  top: 18,
                                ),

                                child: Row(
                                  children: [

                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          approveLeave(
                                            leave.id,
                                          );
                                        },

                                        style:
                                            ElevatedButton
                                                .styleFrom(
                                          backgroundColor:
                                              Colors
                                                  .green,

                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                            vertical: 14,
                                          ),

                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),

                                        icon: const Icon(
                                          Icons.check,
                                          color:
                                              Colors.white,
                                        ),

                                        label:
                                            const Text(
                                          "Approve",

                                          style:
                                              TextStyle(
                                            color: Colors
                                                .white,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 12,
                                    ),

                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          rejectLeave(
                                            leave.id,
                                          );
                                        },

                                        style:
                                            ElevatedButton
                                                .styleFrom(
                                          backgroundColor:
                                              Colors.red,

                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                            vertical: 14,
                                          ),

                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),

                                        icon: const Icon(
                                          Icons.close,
                                          color:
                                              Colors.white,
                                        ),

                                        label:
                                            const Text(
                                          "Reject",

                                          style:
                                              TextStyle(
                                            color: Colors
                                                .white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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