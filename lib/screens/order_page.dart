import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/order_controller.dart';
import '../controllers/inventory_controller.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/order_item.dart';

import 'order_item_edit_page.dart';
import 'new_product_page.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderController>().items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Order'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'New Product',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              final newProduct = await Navigator.push<Product>(
                context,
                MaterialPageRoute(builder: (_) => const NewProductPage()),
              );
              if (newProduct != null) {
                context.read<InventoryController>().addFull(newProduct);
              }
            },
          ),
        ],
      ),
      body:
          orders.isEmpty
              ? const Center(child: Text('Belum ada order'))
              : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (_, i) {
                  final order = orders[i];
                  return ExpansionTile(
                    title: Text('Pelanggan: ${order.customer}'),
                    subtitle: Text(
                      'Total: Rp${order.total.toStringAsFixed(0)}',
                    ),
                    children:
                        order.items.map((item) {
                          return ListTile(
                            title: Text('Produk: ${item.productId}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.note.isNotEmpty)
                                  Text('Catatan: ${item.note}'),
                                Text(
                                  '${item.qty} × Rp${item.unitPrice.toStringAsFixed(0)} = Rp${item.subtotal.toStringAsFixed(0)}',
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final updatedItem =
                                    await Navigator.push<OrderItem>(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                OrderItemEditPage(item: item),
                                      ),
                                    );
                                if (updatedItem != null) {
                                  context.read<OrderController>().updateItem(
                                    order.id,
                                    updatedItem,
                                  );
                                }
                              },
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrderDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addOrderDialog(BuildContext context) {
    final customerCtl = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Tambah Order Baru'),
            content: TextField(
              controller: customerCtl,
              decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<OrderController>().addNew(customerCtl.text);
                  Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }
}
