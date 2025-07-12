import 'dart:io';
import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeCard extends StatelessWidget {
  final Employee data;
  final VoidCallback onLongPress; // untuk edit/hapus

  const EmployeeCard({
    super.key,
    required this.data,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    Widget img;
    if (data.imageUrl != null && data.imageUrl!.isNotEmpty) {
      img = Image.network(
        data.imageUrl!,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    } else if (data.imagePath != null && data.imagePath!.isNotEmpty) {
      img = Image.file(
        File(data.imagePath!),
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    } else {
      img = Container(
        width: 120,
        height: 120,
        color: Colors.grey.shade300,
        child: const Icon(Icons.person, size: 60),
      );
    }

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        width: 220,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(60), child: img),
            const SizedBox(height: 12),
            Text(
              data.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(data.role),
          ],
        ),
      ),
    );
  }
}
