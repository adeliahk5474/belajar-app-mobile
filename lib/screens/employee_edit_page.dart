import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeEditPage extends StatefulWidget {
  final Employee employee;
  const EmployeeEditPage({super.key, required this.employee});

  @override
  State<EmployeeEditPage> createState() => _EmployeeEditPageState();
}

class _EmployeeEditPageState extends State<EmployeeEditPage> {
  late final nameCtl   = TextEditingController(text: widget.employee.name);
  late final roleCtl   = TextEditingController(text: widget.employee.role);
  late final salaryCtl = TextEditingController(text: widget.employee.salary.toStringAsFixed(0));

  @override
  void dispose() {
    nameCtl.dispose();
    roleCtl.dispose();
    salaryCtl.dispose();
    super.dispose();
  }

  void _save() {
    final updated = widget.employee.copyWith(
      name: nameCtl.text,
      role: roleCtl.text,
      salary: double.tryParse(salaryCtl.text) ?? 0,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Karyawan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: nameCtl,   decoration: const InputDecoration(labelText: 'Nama')),
          TextField(controller: roleCtl,   decoration: const InputDecoration(labelText: 'Jabatan')),
          TextField(controller: salaryCtl, decoration: const InputDecoration(labelText: 'Gaji'), keyboardType: TextInputType.number),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _save, child: const Text('Simpan')),
        ],
      ),
    );
  }
}
