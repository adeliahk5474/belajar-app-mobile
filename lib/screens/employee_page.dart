import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/employee_controller.dart';
import '../models/employee.dart';
import '../widgets/employee_card.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  late final PageController _pageCtrl = PageController(viewportFraction: 0.6);

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  // ─────────────────── tambah karyawan
  Future<void> _addDialog(BuildContext ctx) async {
    final nameCtl = TextEditingController();
    final roleCtl = TextEditingController();
    final salaryCtl = TextEditingController();
    XFile? picked;

    await showDialog(
      context: ctx,
      builder:
          (_) => StatefulBuilder(
            // ✅ agar setState lokal hanya dialog
            builder:
                (dCtx, setSt) => AlertDialog(
                  title: const Text('Tambah Karyawan'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            picked = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );
                            setSt(() {}); // rebuild dialog saja
                          },
                          child:
                              picked == null
                                  ? Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.person_add,
                                      size: 60,
                                    ),
                                  )
                                  : Image.file(
                                    File(picked!.path),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: nameCtl,
                          decoration: const InputDecoration(labelText: 'Nama'),
                        ),
                        TextField(
                          controller: roleCtl,
                          decoration: const InputDecoration(
                            labelText: 'Jabatan',
                          ),
                        ),
                        TextField(
                          controller: salaryCtl,
                          decoration: const InputDecoration(labelText: 'Gaji'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
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
                          imagePath: picked?.path,
                        );
                        Navigator.pop(ctx);
                      },
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
          ),
    );
  }

  // ─────────────────── menu hapus
  void _menu(BuildContext ctx, Employee e) {
    showModalBottomSheet(
      context: ctx,
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Hapus'),
                  onTap: () {
                    ctx.read<EmployeeController>().remove(e.id);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employees = context.watch<EmployeeController>().items;

    return Scaffold(
      appBar: AppBar(title: const Text('Karyawan')),
      body:
          employees.isEmpty
              ? const Center(child: Text('Belum ada karyawan'))
              : PageView.builder(
                controller: _pageCtrl,
                itemCount: employees.length,
                itemBuilder: (_, i) {
                  final emp = employees[i];
                  return EmployeeCard(
                    data: emp,
                    onLongPress: () => _menu(context, emp),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
