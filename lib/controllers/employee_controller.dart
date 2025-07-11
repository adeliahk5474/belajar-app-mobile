import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/employee.dart';

class EmployeeController extends ChangeNotifier {
  final List<Employee> _employees = [];
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

  void update(Employee e) {
    final i = _employees.indexWhere((v) => v.id == e.id);
    if (i != -1) {
      _employees[i] = e;
      notifyListeners();
    }
  }

  void remove(String id) {
    _employees.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
