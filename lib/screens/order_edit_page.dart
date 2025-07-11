import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderEditPage extends StatefulWidget {
  final Order order;
  const OrderEditPage({super.key, required this.order});

  @override
  State<OrderEditPage> createState() => _OrderEditPageState();
}

class _OrderEditPageState extends State<OrderEditPage> {
  late final noteCtl  = TextEditingController(text: widget.order.note);
  late final qtyCtl   = TextEditingController(text: widget.order.qty.toString());
  late final priceCtl = TextEditingController(text: widget.order.price.toStringAsFixed(0));

  @override
  void dispose() {
    noteCtl.dispose();
    qtyCtl.dispose();
    priceCtl.dispose();
    super.dispose();
  }

  void _save() {
    final updated = widget.order.copyWith(
      note: noteCtl.text,
      qty: int.tryParse(qtyCtl.text) ?? 0,
      price: double.tryParse(priceCtl.text) ?? 0,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Order')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: noteCtl,  decoration: const InputDecoration(labelText: 'Keterangan')),
          TextField(controller: qtyCtl,   decoration: const InputDecoration(labelText: 'Qty'),   keyboardType: TextInputType.number),
          TextField(controller: priceCtl, decoration: const InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _save, child: const Text('Simpan')),
        ],
      ),
    );
  }
}
