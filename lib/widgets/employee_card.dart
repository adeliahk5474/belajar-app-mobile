import 'package:flutter/material.dart';
import '../models/employee.dart';
import 'app_image.dart';

class EmployeeCard extends StatelessWidget {
  final Employee data;
  final VoidCallback onLongPress;

  const EmployeeCard({
    super.key,
    required this.data,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        width : 220,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImage(
              filePath  : data.imagePath,
              networkUrl: data.imageUrl,
              width     : 120,
              height    : 120,
              radius    : BorderRadius.circular(60),
            ),
            const SizedBox(height: 12),
            Text(data.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(data.role),
          ],
        ),
      ),
    );
  }
}
