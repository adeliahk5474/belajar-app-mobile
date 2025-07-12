import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/employee.dart';

class EmployeeController extends ChangeNotifier {
  final List<Employee> _employees = [];
  List<Employee> get items => List.unmodifiable(_employees);

  // ─────────────────── tambah karyawan
  void add({
    required String name,
    required String role,
    required double salary,
    String? imagePath, // ← jalur lokal jika user pilih foto
    String? imageUrl, // ← url cloud kalau nanti di‑upload
  }) {
    _employees.add(
      Employee(
        id: const Uuid().v4(),
        name: name,
        role: role,
        salary: salary,
        imagePath: imagePath,
        imageUrl: imageUrl,
      ),
    );
    notifyListeners();
  }

  void remove(String id) {
    _employees.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // fungsi lain (update, remove) tetap …
}
