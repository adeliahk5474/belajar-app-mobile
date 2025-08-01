import 'package:flutter/material.dart';
import '../models/order_item.dart';

class OrderItemEditPage extends StatefulWidget {
  final OrderItem item;
  const OrderItemEditPage({super.key, required this.item});

  @override
  State<OrderItemEditPage> createState() => _OrderItemEditPageState();
}

class _OrderItemEditPageState extends State<OrderItemEditPage> {
  late final qtyCtl = TextEditingController(text: widget.item.qty.toString());
  late final priceCtl = TextEditingController(
    text: widget.item.unitPrice.toStringAsFixed(0),
  );

  @override
  void dispose() {
    qtyCtl.dispose();
    priceCtl.dispose();
    super.dispose();
  }

  void _save() {
    final updated = widget.item.copyWith(
      qty: int.tryParse(qtyCtl.text) ?? widget.item.qty,
      unitPrice: double.tryParse(priceCtl.text) ?? widget.item.unitPrice,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Item Order')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Produk ID: ${widget.item.productId}',
              style: const TextStyle(fontSize: 16),
            ),
            TextField(
              controller: qtyCtl,
              decoration: const InputDecoration(labelText: 'Jumlah (Qty)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceCtl,
              decoration: const InputDecoration(labelText: 'Harga per Unit'),
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            ElevatedButton(onPressed: _save, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}
