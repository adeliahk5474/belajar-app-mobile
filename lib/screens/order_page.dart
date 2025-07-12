import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../controllers/inventory_controller.dart';
import '../controllers/order_controller.dart';
import '../models/product.dart';
import '../models/order_item.dart';
import '../widgets/product_card_select.dart';
import 'new_product_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final Map<String, OrderItem> _cart = {}; // productId -> OrderItem

  void _toggleSelect(Product p) {
    setState(() {
      if (_cart.containsKey(p.id)) {
        _cart.remove(p.id);
      } else {
        _cart[p.id] = OrderItem(productId: p.id, qty: 1, unitPrice: p.price);
      }
    });
  }

  void _checkout(BuildContext ctx) {
    if (_cart.isEmpty) return;
    final orderCtrl = ctx.read<OrderController>();
    final id = const Uuid().v4();
    orderCtrl.addNew('Pembeli'); // nama default, bisa pakai dialog
    for (var item in _cart.values) {
      orderCtrl.addItem(id, item);
    }
    setState(() => _cart.clear());
    ScaffoldMessenger.of(
      ctx,
    ).showSnackBar(const SnackBar(content: Text('Order berhasil dibuat')));
  }

  @override
  Widget build(BuildContext context) {
    final invCtrl = context.watch<InventoryController>();
    final products = invCtrl.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Penjualan'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'New Product',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              final p = await Navigator.push<Product>(
                context,
                MaterialPageRoute(builder: (_) => const NewProductPage()),
              );
              if (p != null) invCtrl.addFull(p);
            },
          ),
        ],
      ),
      body:
          products.isEmpty
              ? const Center(child: Text('Belum ada produk'))
              : ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, i) {
                  final p = products[i];
                  return ProductCardSelect(
                    product: p,
                    selected: _cart.containsKey(p.id),
                    onTap: () => _toggleSelect(p),
                    onDelete: () {
                      invCtrl.remove(p.id);
                      setState(() => _cart.remove(p.id));
                    },
                  );
                },
              ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, size: 28),
              color: _cart.isNotEmpty ? Colors.teal : Colors.grey,
              onPressed: _cart.isNotEmpty ? () => _checkout(context) : null,
            ),
            const Spacer(),
            Text('Item dipilih: ${_cart.length}'),
          ],
        ),
      ),
    );
  }
}
