import 'package:emp_management_flutterside/models/employee.dart';
import 'package:emp_management_flutterside/services/employee_service.dart';
import 'package:emp_management_flutterside/ui/adminUI/employee/add.dart';
import 'package:flutter/material.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final EmployeeService _service = EmployeeService();

  late Future<List<EmployeeResponseDto>> _employees;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  void _loadEmployees() {
    _employees = _service.getEmployees();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadEmployees();
    });
  }

  TextStyle subStyle = TextStyle(
    fontSize: 17,
    color: const Color.fromARGB(255, 97, 5, 245),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Employees",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 196, 57, 238),
          ),
        ),
        actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(Icons.add),
                  Text(
                    "Add",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmployeeForm()),
              ).then((value) {
                if (value == true) {
                  _refresh();
                  _loadEmployees();
                }
              });
            },
          ),
        ],
      ),

      body: FutureBuilder<List<EmployeeResponseDto>>(
        future: _employees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final employees = snapshot.data ?? [];

          if (employees.isEmpty) {
            return const Center(child: Text("No employees found"));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final emp = employees[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 8,
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: ListTile(
                      title: Text(
                        emp.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emp.email,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text("Dept: ${emp.departmentName}", style: subStyle),
                          Text("Role: ${emp.roleName}", style: subStyle),
                          Text("Salary: ${emp.basicSalary}", style: subStyle),
                        ],
                      ),

                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EmployeeForm(employee: emp),
                                  ),
                                ).then((value) {
                                  if (value == true) {
                                    _refresh();
                                  }
                                });
                              },
                              icon: const Icon(Icons.edit, color: Colors.blue),
                            ),

                            IconButton(
                              onPressed: () async {
                                await _service.deleteEmployee(emp.id);
                                _refresh();
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
