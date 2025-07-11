import 'package:flutter/material.dart';
import '../models/product.dart';

class InventoryEditPage extends StatefulWidget {
  final Product product;
  const InventoryEditPage({super.key, required this.product});

  @override
  State<InventoryEditPage> createState() => _InventoryEditPageState();
}

class _InventoryEditPageState extends State<InventoryEditPage> {
  late final _nameCtl      = TextEditingController(text: widget.product.name);
  late final _categoryCtl  = TextEditingController(text: widget.product.category);
  late final _unitCtl      = TextEditingController(text: widget.product.unit);
  late final _priceCtl     = TextEditingController(text: widget.product.price.toStringAsFixed(0));
  late final _stockCtl     = TextEditingController(text: widget.product.stockQty.toString());
  late final _minStockCtl  = TextEditingController(text: widget.product.minStock.toString());

  @override
  void dispose() {
    _nameCtl.dispose();
    _categoryCtl.dispose();
    _unitCtl.dispose();
    _priceCtl.dispose();
    _stockCtl.dispose();
    _minStockCtl.dispose();
    super.dispose();
  }

  void _save() {
    final updated = Product(
      id: widget.product.id,
      name: _nameCtl.text,
      category: _categoryCtl.text,
      unit: _unitCtl.text,
      price: double.tryParse(_priceCtl.text) ?? 0,
      stockQty: int.tryParse(_stockCtl.text) ?? 0,
      minStock: int.tryParse(_minStockCtl.text) ?? 0,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Produk')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _nameCtl,      decoration: const InputDecoration(labelText: 'Nama')),
          TextField(controller: _categoryCtl,  decoration: const InputDecoration(labelText: 'Kategori')),
          TextField(controller: _unitCtl,      decoration: const InputDecoration(labelText: 'Satuan (pcs, kg, dll)')),
          TextField(controller: _priceCtl,     decoration: const InputDecoration(labelText: 'Harga'),         keyboardType: TextInputType.number),
          TextField(controller: _stockCtl,     decoration: const InputDecoration(labelText: 'Stok'),          keyboardType: TextInputType.number),
          TextField(controller: _minStockCtl,  decoration: const InputDecoration(labelText: 'Stok Minimum'),  keyboardType: TextInputType.number),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _save, child: const Text('Simpan')),
        ],
      ),
    );
  }
}
