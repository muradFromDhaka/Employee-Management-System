import 'package:emp_management_flutterside/models/leaveRequest.dart';
import 'package:emp_management_flutterside/services/leaveRequest_service.dart';
import 'package:flutter/material.dart';

class LeaveRequestForm extends StatefulWidget {
  final LeaveResponseDTO? leaveResponseDto;

  const LeaveRequestForm({super.key, this.leaveResponseDto});

  @override
  State<LeaveRequestForm> createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final _formKey = GlobalKey<FormState>();

  final _leaveRequestService = LeaveRequestService();

  final TextEditingController reasonController = TextEditingController();

  DateTime? fromDate;
  DateTime? toDate;

  bool isLoading = false;


  // =========================
  // PICK DATE
  // =========================
  Future<void> pickDate(bool isFrom) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      if (isFrom) {
        fromDate = pickedDate;
      } else {
        toDate = pickedDate;
      }
    });
  }

  // =========================
  // SUBMIT LEAVE
  // =========================
  Future<void> submitLeave() async {
    if (!_formKey.currentState!.validate()) return;

    if (fromDate == null || toDate == null) {
      showMessage("Please select leave dates");
      return;
    }

    if (fromDate!.isAfter(toDate!)) {
      showMessage("Start date cannot be after end date");
      return;
    }

    setState(() => isLoading = true);

    try {
      final request = LeaveRequestDTO(
        reason: reasonController.text.trim(),
        startDate: fromDate!,
        endDate: toDate!,
      );

      final response = await _leaveRequestService.applyLeave(request);

      if (!mounted) return;

      showMessage("Leave request submitted successfully", isError: false);
      Navigator.pop(context, response);
    } catch (e) {
      print("e--------------------------- $e");
      showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // =========================
  // SNACKBAR
  // =========================
  void showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // =========================
  // DISPOSE
  // =========================
  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Apply Leave"),backgroundColor: const Color.fromARGB(255, 135, 192, 238)),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              // =========================
              // START DATE
              // =========================
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.grey),
                ),

                title: Text(
                  fromDate == null
                      ? "Select Start Date"
                      : "Start Date: "
                            "${fromDate!.day}-${fromDate!.month}-${fromDate!.year}",
                ),

                trailing: const Icon(Icons.calendar_month),

                onTap: () => pickDate(true),
              ),

              const SizedBox(height: 15),

              // =========================
              // END DATE
              // =========================
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.grey),
                ),

                title: Text(
                  toDate == null
                      ? "Select End Date"
                      : "End Date: "
                            "${toDate!.day}-${toDate!.month}-${toDate!.year}",
                ),

                trailing: const Icon(Icons.calendar_month),

                onTap: () => pickDate(false),
              ),

              const SizedBox(height: 20),

              // =========================
              // REASON
              // =========================
              TextFormField(
                controller: reasonController,
                maxLines: 5,

                decoration: const InputDecoration(
                  labelText: "Reason",
                  hintText: "Enter leave reason...",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Reason is required";
                  }

                  if (value.trim().length < 5) {
                    return "Reason too short";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              // =========================
              // SUBMIT BUTTON
              // =========================
              SizedBox(
                height: 50,

                child: ElevatedButton(
                  onPressed: isLoading ? null : submitLeave,

                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color.fromARGB(255, 252, 251, 251),
                          ),
                        )
                      : const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
