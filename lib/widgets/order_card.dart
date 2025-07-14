import 'package:flutter/material.dart';
import '../models/order.dart';
import 'app_image.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Ambil gambar item pertama (jika ada)
    final firstItem = order.items.isNotEmpty ? order.items.first : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: firstItem == null
            ? const Icon(Icons.receipt_long, size: 40)
            : AppImage(
                filePath  : firstItem.imagePath,
                networkUrl: firstItem.imageUrl,
                width     : 64,
                height    : 64,
                radius    : BorderRadius.circular(8),
              ),
        title: Text('Pelanggan: ${order.customer}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: ${order.date.toLocal()}'),
            Text('Total: Rp${order.total.toStringAsFixed(0)}'),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
