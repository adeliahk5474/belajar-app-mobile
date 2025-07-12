import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/employee_controller.dart';
import '../models/employee.dart';
import 'employee_edit_page.dart';

class EmployeePage extends StatelessWidget {
  const EmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<EmployeeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Karyawan')),
      body:
          ctrl.items.isEmpty
              ? const Center(child: Text('Belum ada karyawan'))
              : ListView.builder(
                itemCount: ctrl.items.length,
                itemBuilder: (_, i) {
                  final e = ctrl.items[i];
                  return ListTile(
                    leading: const Icon(Icons.badge),
                    title: Text(e.name),
                    subtitle: Text(
                      '${e.role} • Gaji: Rp${e.salary.toStringAsFixed(0)}',
                    ),
                    onTap: () => _showMenu(context, e),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // ───────────────────────────── Tambah karyawan
  void _showAddDialog(BuildContext ctx) {
    final nameCtl = TextEditingController();
    final roleCtl = TextEditingController();
    final salaryCtl = TextEditingController();
    showDialog(
      context: ctx,
      builder:
          (_) => AlertDialog(
            title: const Text('Tambah Karyawan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtl,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                TextField(
                  controller: roleCtl,
                  decoration: const InputDecoration(labelText: 'Jabatan'),
                ),
                TextField(
                  controller: salaryCtl,
                  decoration: const InputDecoration(labelText: 'Gaji'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  ctx.read<EmployeeController>().add(
                    name: nameCtl.text,
                    role: roleCtl.text,
                    salary: double.tryParse(salaryCtl.text) ?? 0,
                  );
                  Navigator.pop(ctx);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  // ───────────────────────────── Menu bottom‑sheet
  void _showMenu(BuildContext ctx, Employee emp) {
    showModalBottomSheet(
      context: ctx,
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final updated = await Navigator.push<Employee>(
                      ctx,
                      MaterialPageRoute(
                        builder: (_) => EmployeeEditPage(employee: emp),
                      ),
                    );
                    if (updated != null)
                      ctx.read<EmployeeController>().update(updated);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Hapus'),
                  onTap: () {
                    ctx.read<EmployeeController>().remove(emp.id);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
