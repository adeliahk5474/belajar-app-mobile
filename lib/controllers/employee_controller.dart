import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/employee.dart';

class EmployeeController extends ChangeNotifier {
  final _employees = <Employee>[];

  List<Employee> get items => List.unmodifiable(_employees);

  void add({required String name, required String role, required double salary}) {
    _employees.add(Employee(
      id: const Uuid().v4(),
      name: name,
      role: role,
      salary: salary,
    ));
    notifyListeners();
  }

  void update(Employee updated) {
    final i = _employees.indexWhere((e) => e.id == updated.id);
    if (i != -1) {
      _employees[i] = updated;
      notifyListeners();
    }
  }

  void remove(String id) {
    _employees.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
