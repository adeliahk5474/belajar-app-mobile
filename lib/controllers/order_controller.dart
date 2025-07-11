import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/product.dart';
import 'inventory_controller.dart';

class OrderController extends ChangeNotifier {
  final InventoryController inventory;
  OrderController(this.inventory);

  final List<Order> _orders = [];
  List<Order> get items => List.unmodifiable(_orders);

  // ───────────────────────────── tambah order
  /// Return `true` jika stok cukup & order tersimpan
  bool addOrder({
    required String customer,
    required List<OrderItem> items,
  }) {
    // cek stok untuk tiap item
    for (final it in items) {
      final prod = inventory.items.firstWhere((p) => p.id == it.productId);

      if (prod.isMenu) {
        if (!inventory.consumeRecipe(prod.recipe!, it.qty)) return false;
      } else {
        if (!inventory.adjustStock(it.productId, -it.qty)) return false;
      }
    }

    _orders.add(Order(
      id: const Uuid().v4(),
      customer: customer,
      date: DateTime.now(),
      items: items,
    ));
    notifyListeners();
    return true;
  }

  // ───────────────────────────── update / hapus
  void update(Order o) {
    final i = _orders.indexWhere((e) => e.id == o.id);
    if (i != -1) {
      _orders[i] = o;
      notifyListeners();
    }
  }

  /// Hapus order & kembalikan stok
  void remove(String id) {
    final order = _orders.firstWhere((e) => e.id == id, orElse: () => Order(id: '', customer: '', date: DateTime.now(), items: []));
    if (order.id.isEmpty) return;

    for (final it in order.items) {
      final prod = inventory.items.firstWhere((p) => p.id == it.productId, orElse: () => Product(id: '', name: '', category: '', unit: '', price: 0, stockQty: 0));
      if (prod.id.isEmpty) continue;

      if (prod.isMenu) {
        // balikan stok bahan
        for (final r in prod.recipe!) {
          inventory.adjustStock(r.inventoryId, r.qty * it.qty);
        }
      } else {
        inventory.adjustStock(it.productId, it.qty);
      }
    }

    _orders.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
