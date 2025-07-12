import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // pilih gambar: URL → File → placeholder
    Widget img;
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      img = Image.network(
        product.imageUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    } else if (product.imagePath != null && product.imagePath!.isNotEmpty) {
      img = Image.file(
        File(product.imagePath!),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    } else {
      img = Container(
        width: 80,
        height: 80,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(8), child: img),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Stok : ${product.stockQty} ${product.unit}'),
                    Text('Harga : Rp${product.price.toStringAsFixed(0)}'),
                  ],
                ),
              ),
              Text(product.category),
            ],
          ),
        ),
      ),
    );
  }
}
