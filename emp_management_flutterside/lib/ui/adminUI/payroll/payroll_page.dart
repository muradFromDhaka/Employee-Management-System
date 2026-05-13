import 'dart:convert';

import 'package:emp_management_flutterside/models/employee.dart';
import 'package:emp_management_flutterside/models/payroll.dart';
import 'package:emp_management_flutterside/services/employee_service.dart';
import 'package:emp_management_flutterside/services/payroll_service.dart';
import 'package:flutter/material.dart';

class PayrollPage extends StatefulWidget {
  const PayrollPage({super.key});

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  final PayrollService _service = PayrollService();
  final EmployeeService _employeeService = EmployeeService();

  List<PayrollResponseDto> payrolls = [];
  List<EmployeeResponseDto> _employees = [];
  bool isLoading = false;

  int? employeeId;
  String? selectedMonth;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    selectedMonth = getCurrentYearMonth();
    _loadPayroll();
    _loadExpense();
    _loadEmployee();
  }

  Future<void> _loadEmployee() async {
    try {
      final data = await _employeeService.getEmployees();

      setState(() {
        _employees = data; // 🔥 important fix
      });
    } catch (e) {
      debugPrint("Employee load error: $e");
    }
  }

  String getCurrentYearMonth() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}";
  }

  String parseError(dynamic e) {
    final text = e.toString();

    try {
      final start = text.indexOf("{");
      final end = text.lastIndexOf("}");

      if (start != -1 && end != -1) {
        final jsonStr = text.substring(start, end + 1);
        final data = jsonDecode(jsonStr);

        return data["message"] ?? "Something went wrong";
      }
    } catch (_) {}

    if (text.contains("401")) {
      return "Session expired. Please login again.";
    }

    if (text.contains("Payroll already generated")) {
      return "Payroll already generated for this month.";
    }

    return "Something went wrong";
  }

  Future<void> generatePayroll(int employeeId) async {
    try {
      await _service.generatePayroll(
        employeeId: employeeId,
        month: selectedMonth!,
      );

      await _loadPayroll();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payroll generated successfully")),
      );
    } catch (e) {
      if (!mounted) return;

      final message = parseError(e);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _loadPayroll() async {
    setState(() => isLoading = true);

    try {
      final month = selectedMonth;
      final data = await _service.getMonthlyPayroll(month!);

      setState(() {
        payrolls = data;
      });
    } catch (e) {
      debugPrint("Payroll load error: $e");
    }

    setState(() => isLoading = false);
  }

  Future<void> _loadExpense() async {
    try {
      final data = await _service.getTotalExpense(selectedMonth!);

      setState(() {
        totalExpense = data;
      });
    } catch (e) {
      debugPrint("Expense error: $e");
    }
  }

  Future<void> _pickMonth() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: "Select Month",
    );

    if (picked != null) {
      final newMonth = formatYearMonth(picked);

      setState(() {
        selectedMonth = newMonth;
      });

      await _loadPayroll();
      await _loadExpense();
    }
  }

  void _showGenerateDialog() {
     final parentContext = context;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Generate Payroll"),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: employeeId,
                    items: _employees.map((e) {
                      return DropdownMenuItem<int>(
                        value: e.id,
                        child: Text(e.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        employeeId = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Select Employee",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: employeeId == null
                      ? null
                      : () async {
                          try {
                            await _service.generatePayroll(
                              employeeId: employeeId!,
                              month: selectedMonth!,
                            );

                            if (!mounted) return;

                            Navigator.pop(context);

                            await _loadPayroll();
                            await _loadExpense();

                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              const SnackBar(
                                content: Text("Payroll generated successfully"),
                                backgroundColor: Color.fromARGB(255, 111, 235, 214),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;

                            final message = parseError(e);

                            ScaffoldMessenger.of(
                              parentContext,
                            ).showSnackBar(SnackBar(content: Text(message),backgroundColor: const Color.fromARGB(255, 223, 94, 240),));
                          }
                        },
                  child: const Text("Generate"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(
        title: const Text("Payroll Management"),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            onPressed: _pickMonth,
            icon: const Icon(Icons.calendar_month),
          ),
          IconButton(
            onPressed: _showGenerateDialog,
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: Column(
        children: [
          // ================= SUMMARY CARD =================
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Month: $selectedMonth",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Total Expense: \$${totalExpense.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // ================= LIST =================
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : payrolls.isEmpty
                ? const Center(child: Text("No payroll data"))
                : ListView.builder(
                    itemCount: payrolls.length,
                    itemBuilder: (context, index) {
                      final p = payrolls[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.payments,
                            color: Colors.green,
                          ),
                          title: Text(p.employeeName),
                          subtitle: Text("Month: ${p.month}"),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "\$${p.finalSalary}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "ID: ${p.employeeId}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
