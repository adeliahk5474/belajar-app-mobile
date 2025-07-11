import 'package:flutter/material.dart';

class Employee {
  final String id;
  String name;
  String role;
  double salary;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.salary,
  });

  Employee copyWith({String? name, String? role, double? salary}) => Employee(
    id: id,
    name: name ?? this.name,
    role: role ?? this.role,
    salary: salary ?? this.salary,
  );
}
