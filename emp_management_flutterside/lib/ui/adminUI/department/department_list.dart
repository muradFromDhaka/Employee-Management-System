import 'package:emp_management_flutterside/models/department.dart';
import 'package:emp_management_flutterside/services/department_service.dart';
import 'package:emp_management_flutterside/ui/adminUI/department/department_form.dart';
import 'package:flutter/material.dart';

class DepartmentList extends StatefulWidget {
  const DepartmentList({super.key});

  @override
  State<DepartmentList> createState() => _DepartmentListState();
}

class _DepartmentListState extends State<DepartmentList> {
  final DepartmentService _service = DepartmentService();

  Future<List<DepartmentResponseDto>>? _departments;
  Map<int, int> _employeeCounts = {};

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    final departments = await _service.getDepartments();

    Map<int, int> counts = {};

    await Future.wait(
      departments.map((dept) async {
        counts[dept.id] = await _service.countEmployeesInDepartment(dept.id);
      }),
    );

    setState(() {
      _departments = Future.value(departments);
      _employeeCounts = counts;
    });
  }

  Future<void> _refresh() async {
    _loadDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Departments"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DepartmentForm()),
              ).then( (_) => _refresh());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<DepartmentResponseDto>>(
        future: _departments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final departments = snapshot.data ?? [];

          if (departments.isEmpty) {
            return const Center(child: Text("No departments found"));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: departments.length,
              itemBuilder: (context, index) {
                final dept = departments[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dept.depName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Employee: ${_employeeCounts[dept.id] ?? 0}",
                              ),
                              SizedBox(height: 8),
                              Text("Location: ${dept.location}"),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                final req = DepartmentRequestDto(
                                  depName: dept.depName,
                                  location: dept.location,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DepartmentForm(
                                      departmentId: dept.id,
                                      department: req,
                                    ),
                                  ),
                                ).then((_) => _refresh());
                              },
                              icon: Icon(Icons.edit, color: Colors.blue),
                            ),
                            IconButton(
                              onPressed: () async {
                                // Call delete API
                                await _service.deleteDepartment(dept.id);
                                _refresh();
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
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
