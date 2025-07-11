import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/order_controller.dart';
import '../controllers/inventory_controller.dart';
import '../models/order.dart';
import '../models/product.dart';

import 'order_edit_page.dart';
import 'new_product_page.dart';   // ← halaman tambah produk/menu

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderCtrl = context.watch<OrderController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Order'),
        actions: [
          // Tombol NEW PRODUCT / MENU di sudut kanan app‑bar
          TextButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('New Product', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              final newProduct = await Navigator.push<Product>(
                context,
                MaterialPageRoute(builder: (_) => const NewProductPage()),
              );
              if (newProduct != null) {
                // tambahkan ke inventory
                context.read<InventoryController>().addFull(newProduct);
              }
            },
          ),
        ],
      ),
      body: orderCtrl.items.isEmpty
          ? const Center(child: Text('Belum ada order'))
          : ListView.builder(
              itemCount: orderCtrl.items.length,
              itemBuilder: (_, i) {
                final o = orderCtrl.items[i];
                return ListTile(
                  title: Text(o.note),
                  subtitle: Text(
                      '${o.qty} × Rp${o.price.toStringAsFixed(0)} = Rp${o.total.toStringAsFixed(0)}'),
                  onTap: () => _showMenu(context, o),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // ───────────────────────────── dialog tambah order
  void _showAddDialog(BuildContext ctx) {
    final noteCtl  = TextEditingController();
    final qtyCtl   = TextEditingController(text: '1');
    final priceCtl = TextEditingController();

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Order'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: noteCtl,
              decoration: const InputDecoration(labelText: 'Keterangan')),
          TextField(
              controller: qtyCtl,
              decoration: const InputDecoration(labelText: 'Qty'),
              keyboardType: TextInputType.number),
          TextField(
              controller: priceCtl,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              ctx.read<OrderController>().add(
                    note: noteCtl.text,
                    qty: int.tryParse(qtyCtl.text) ?? 0,
                    price: double.tryParse(priceCtl.text) ?? 0,
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────── menu bottom‑sheet
  void _showMenu(BuildContext ctx, Order o) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () async {
              Navigator.pop(ctx);
              final updated = await Navigator.push<Order>(
                ctx,
                MaterialPageRoute(builder: (_) => OrderEditPage(order: o)),
              );
              if (updated != null) ctx.read<OrderController>().update(updated);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Hapus'),
            onTap: () {
              ctx.read<OrderController>().remove(o.id);
              Navigator.pop(ctx);
            },
          ),
        ]),
      ),
    );
  }
}
