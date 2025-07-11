import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/inventory_controller.dart';
import '../models/product.dart';
import 'inventory_edit_page.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InventoryController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Inventori')),
      body: controller.items.isEmpty
          ? const Center(child: Text('Belum ada produk'))
          : ListView.builder(
              itemCount: controller.items.length,
              itemBuilder: (_, i) {
                final p = controller.items[i];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text('Stok: ${p.stockQty} ${p.unit} • Harga: Rp${p.price.toStringAsFixed(0)}'),
                  trailing: Text(p.category),
                  onTap: () => _showOptions(context, p),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext ctx) {
    final nameCtl = TextEditingController();
    final categoryCtl = TextEditingController();
    final unitCtl = TextEditingController();
    final priceCtl = TextEditingController();
    final stockCtl = TextEditingController();
    final minStockCtl = TextEditingController();

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Produk'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nameCtl, decoration: const InputDecoration(labelText: 'Nama')),
            TextField(controller: categoryCtl, decoration: const InputDecoration(labelText: 'Kategori')),
            TextField(controller: unitCtl, decoration: const InputDecoration(labelText: 'Satuan (pcs, kg, dll)')),
            TextField(controller: priceCtl, decoration: const InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
            TextField(controller: stockCtl, decoration: const InputDecoration(labelText: 'Stok'), keyboardType: TextInputType.number),
            TextField(controller: minStockCtl, decoration: const InputDecoration(labelText: 'Stok Minimum'), keyboardType: TextInputType.number),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              ctx.read<InventoryController>().add(
                    name: nameCtl.text,
                    category: categoryCtl.text,
                    unit: unitCtl.text,
                    price: double.tryParse(priceCtl.text) ?? 0,
                    stockQty: int.tryParse(stockCtl.text) ?? 0,
                    minStock: int.tryParse(minStockCtl.text) ?? 0,
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext ctx, Product p) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Tambah stok'),
            onTap: () {
              ctx.read<InventoryController>().adjustStock(p.id, 1);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.remove),
            title: const Text('Kurangi stok'),
            onTap: () {
              ctx.read<InventoryController>().adjustStock(p.id, -1);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit detail'),
            onTap: () async {
              Navigator.pop(ctx);
              final updated = await Navigator.push<Product>(
                ctx,
                MaterialPageRoute(builder: (_) => InventoryEditPage(product: p)),
              );
              if (updated != null) {
                ctx.read<InventoryController>().update(updated);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Hapus'),
            onTap: () {
              ctx.read<InventoryController>().remove(p.id);
              Navigator.pop(ctx);
            },
          ),
        ]),
      ),
    );
  }
}
