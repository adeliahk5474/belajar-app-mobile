import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../controllers/inventory_controller.dart';
import '../controllers/order_controller.dart';
import '../models/product.dart';
import '../models/order_item.dart';
import '../widgets/product_card_select.dart';
import '../widgets/order_card.dart';
import 'new_product_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  /* cart sementara: productId → OrderItem */
  final Map<String, OrderItem> _cart = {};

  /* toggle pilih 1 produk */
  void _toggleSelect(Product p) {
    setState(() {
      if (_cart.containsKey(p.id)) {
        _cart.remove(p.id);
      } else {
        _cart[p.id] = OrderItem(productId: p.id, qty: 1, unitPrice: p.price);
      }
    });
  }

  /* buat order dari cart */
  Future<void> _checkout() async {
    if (_cart.isEmpty) return;
    final orderCtrl = context.read<OrderController>();
    final orderId = await orderCtrl.addNew('Pembeli');

    for (final item in _cart.values) {
      await orderCtrl.addItem(orderId, item);
    }
    setState(() => _cart.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order berhasil dibuat')),
    );
  }

  /* dialog tambah produk/menu baru */
  Future<void> _addProduct() async {
    final invCtrl = context.read<InventoryController>();
    final p = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (_) => const NewProductPage()),
    );
    if (p != null) invCtrl.addFull(p);
  }

  @override
  Widget build(BuildContext context) {
    final inv     = context.watch<InventoryController>().items;
    final orders  = context.watch<OrderController>().items;   // untuk card daftar
    final hasCart = _cart.isNotEmpty;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen Order'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add_shopping_cart), text: 'Buat Order'),
              Tab(icon: Icon(Icons.receipt_long),      text: 'Riwayat'),
            ],
          ),
          actions: [
            IconButton(icon: const Icon(Icons.add), onPressed: _addProduct),
          ],
        ),

        /* ---------- TAB VIEW ---------- */
        body: TabBarView(
          children: [
            /* ── Tab 0: pilih produk ── */
            inv.isEmpty
                ? const Center(child: Text('Belum ada produk'))
                : ListView.builder(
                    itemCount: inv.length,
                    itemBuilder: (_, i) {
                      final p = inv[i];
                      return ProductCardSelect(
                        product: p,
                        selected: _cart.containsKey(p.id),
                        onTap:  () => _toggleSelect(p),
                        onDelete: () {
                          context.read<InventoryController>().remove(p.id);
                          setState(() => _cart.remove(p.id));
                        },
                      );
                    },
                  ),

            /* ── Tab 1: riwayat order ── */
            orders.isEmpty
                ? const Center(child: Text('Belum ada order'))
                : PageView.builder(
                    controller: PageController(viewportFraction: 0.9),
                    itemCount: orders.length,
                    itemBuilder: (_, i) => OrderCard(order: orders[i]),
                  ),
          ],
        ),

        /* ---------- FAB ---------- */
        floatingActionButton: hasCart
            ? FloatingActionButton(
                onPressed: _checkout,
                tooltip: 'Selesaikan Order',
                child: const Icon(Icons.shopping_cart_checkout_rounded),
              )
            : null,

        bottomNavigationBar: hasCart
            ? BottomAppBar(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text('Item dipilih: ${_cart.length}'),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _checkout,
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
