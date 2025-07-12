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
  late final noteCtl = TextEditingController(text: widget.item.note ?? '');

  @override
  void dispose() {
    qtyCtl.dispose();
    priceCtl.dispose();
    noteCtl.dispose();
    super.dispose();
  }

  void _save() {
    final updated = widget.item.copyWith(
      qty: int.tryParse(qtyCtl.text) ?? 0,
      unitPrice: double.tryParse(priceCtl.text) ?? 0,
      note: noteCtl.text,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Item Order')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: qtyCtl,
            decoration: const InputDecoration(labelText: 'Qty'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: priceCtl,
            decoration: const InputDecoration(labelText: 'Harga Satuan'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: noteCtl,
            decoration: const InputDecoration(labelText: 'Catatan'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _save, child: const Text('Simpan')),
        ],
      ),
    );
  }
}
