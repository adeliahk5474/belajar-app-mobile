import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';

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
    final img = product.imageUrl;
    final local = product.imagePath;

    Widget imageWidget;
    if (img != null && img.isNotEmpty) {
      imageWidget = Image.network(
        img,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    } else if (local != null && local.isNotEmpty) {
      imageWidget = Image.file(
        File(local),
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = Container(
        width: 70,
        height: 70,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageWidget,
        ),
        title: Text(product.name),
        subtitle: Text(
          'Stock: ${product.stockQty}  •  Rp${product.price.toStringAsFixed(0)}',
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
