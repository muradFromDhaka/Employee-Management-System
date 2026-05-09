import 'package:emp_management_flutterside/models/department.dart';
import 'package:emp_management_flutterside/services/department_service.dart';
import 'package:flutter/material.dart';

class DepartmentForm extends StatefulWidget {
  final int? departmentId;
  final DepartmentRequestDto? department;

  const DepartmentForm({super.key, this.departmentId, this.department});

  @override
  State<DepartmentForm> createState() => _DepartmentFormState();
}

class _DepartmentFormState extends State<DepartmentForm> {
  final _formKey = GlobalKey<FormState>();
  final DepartmentService _service = DepartmentService();

  late TextEditingController _nameController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.department?.depName ?? '',
    );

    _locationController = TextEditingController(
      text: widget.department?.location ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final request = DepartmentRequestDto(
        depName: _nameController.text,
        location: _locationController.text,
      );

      try {
        if (widget.department != null) {
          await _service.updateDepartment(widget.departmentId!, request);
        } else {
          await _service.createDepartment(request);
        }

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.department != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Department' : 'Create Department'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Department Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Department name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(isEdit ? 'Update' : 'Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
