import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/employee.dart';
import '../util/database_helper.dart';

class EmployeeController extends ChangeNotifier {
  final List<Employee> _employees = [];
  List<Employee> get items => List.unmodifiable(_employees);

  EmployeeController() {
    _load(); // load dari DB saat inisialisasi
  }

  Future<void> _load() async {
    final rows = await DBHelper.getEmployees();
    _employees
      ..clear()
      ..addAll(rows.map(Employee.fromMap));
    notifyListeners();
  }

  Future<void> add({
    required String name,
    required String role,
    required double salary,
    String? imagePath,
    String? imageUrl,
  }) async {
    final e = Employee(
      id: const Uuid().v4(),
      name: name,
      role: role,
      salary: salary,
      imagePath: imagePath,
      imageUrl: imageUrl,
    );
    await DBHelper.insertEmployee(e.id, e.name, e.role, e.salary, e.imageUrl);
    _employees.add(e);
    notifyListeners();
  }

  Future<void> update(Employee updated) async {
    await DBHelper.updateEmployee(
        updated.id, updated.name, updated.role, updated.salary, updated.imageUrl);
    final i = _employees.indexWhere((e) => e.id == updated.id);
    if (i != -1) {
      _employees[i] = updated;
      notifyListeners();
    }
  }

  Future<void> remove(String id) async {
    await DBHelper.deleteEmployee(id);
    _employees.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
