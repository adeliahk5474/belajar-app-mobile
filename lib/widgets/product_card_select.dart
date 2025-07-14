import 'package:flutter/material.dart';
import '../models/product.dart';
import 'app_image.dart';

class ProductCardSelect extends StatelessWidget {
  final Product product;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProductCardSelect({
    super.key,
    required this.product,
    required this.selected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: AppImage(
          filePath  : product.imagePath,
          networkUrl: product.imageUrl,
          width     : 72,
          height    : 72,
          radius    : BorderRadius.circular(8),
        ),
        title: Text(product.name),
        subtitle: Text(
          'Stock: ${product.stockQty} • Rp${product.price.toStringAsFixed(0)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? Colors.teal : Colors.grey,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
