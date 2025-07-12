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

  // ────────────────────────────── BUAT ORDER KOSONG
  String addNew(String customer) {
    final id = const Uuid().v4();
    _orders.add(
      Order(id: id, customer: customer, date: DateTime.now(), items: []),
    );
    notifyListeners();
    return id;
  }

  // ────────────────────────────── TAMBAH 1 ITEM
  /// Return true jika stok cukup & item tersimpan
  bool addItem(String orderId, OrderItem item) {
    final order = _orders.firstWhere(
      (o) => o.id == orderId,
      orElse:
          () => Order(id: '', customer: '', date: DateTime.now(), items: []),
    );
    if (order.id.isEmpty) return false;

    final prod = inventory.items.firstWhere(
      (p) => p.id == item.productId,
      orElse:
          () => Product(
            id: '',
            name: '',
            category: '',
            unit: '',
            price: 0,
            stockQty: 0,
          ),
    );
    if (prod.id.isEmpty) return false;

    // cek & kurangi stok
    if (prod.isMenu) {
      if (!inventory.consumeRecipe(prod.recipe!, item.qty)) return false;
    } else {
      if (!inventory.adjustStock(item.productId, -item.qty)) return false;
    }

    order.items.add(item);
    notifyListeners();
    return true;
  }

  // ────────────────────────────── UPDATE 1 ITEM
  /// Update item & sesuaikan selisih stok
  bool updateItem(String orderId, OrderItem updated) {
    final order = _orders.firstWhere(
      (o) => o.id == orderId,
      orElse:
          () => Order(id: '', customer: '', date: DateTime.now(), items: []),
    );
    if (order.id.isEmpty) return false;

    final idx = order.items.indexWhere((i) => i.productId == updated.productId);
    if (idx == -1) return false;

    final old = order.items[idx];

    final prod = inventory.items.firstWhere((p) => p.id == updated.productId);
    final deltaQty = updated.qty - old.qty;

    // Jika deltaQty > 0 ⇒ butuh stok tambahan; <0 ⇒ kembalikan stok
    if (deltaQty != 0) {
      if (prod.isMenu) {
        final mult = deltaQty > 0 ? -1 : 1;
        final ok =
            inventory.consumeRecipe(
              prod.recipe!,
              deltaQty.abs() * (deltaQty > 0 ? 1 : -1) * mult,
            ) ||
            deltaQty < 0; // jika mengembalikan stok menu
        if (!ok) return false;
      } else {
        final ok = inventory.adjustStock(updated.productId, -deltaQty);
        if (!ok) return false;
      }
    }

    order.items[idx] = updated;
    notifyListeners();
    return true;
  }

  // ────────────────────────────── HAPUS 1 ITEM
  void removeItem(String orderId, String productId) {
    final order = _orders.firstWhere(
      (o) => o.id == orderId,
      orElse:
          () => Order(id: '', customer: '', date: DateTime.now(), items: []),
    );
    if (order.id.isEmpty) return;

    final item = order.items.firstWhere(
      (i) => i.productId == productId,
      orElse: () => OrderItem(productId: '', qty: 0, unitPrice: 0),
    );
    if (item.productId.isEmpty) return;

    final prod = inventory.items.firstWhere((p) => p.id == productId);
    if (prod.isMenu) {
      for (final r in prod.recipe!) {
        inventory.adjustStock(r.inventoryId, r.qty * item.qty);
      }
    } else {
      inventory.adjustStock(productId, item.qty);
    }

    order.items.removeWhere((i) => i.productId == productId);
    notifyListeners();
  }

  // ────────────────────────────── UPDATE INFO ORDER
  void updateOrderInfo(String orderId, {String? customer, DateTime? date}) {
    final order = _orders.firstWhere(
      (o) => o.id == orderId,
      orElse:
          () => Order(id: '', customer: '', date: DateTime.now(), items: []),
    );
    if (order.id.isEmpty) return;

    order.customer = customer ?? order.customer;
    order.date = date ?? order.date;
    notifyListeners();
  }

  // ────────────────────────────── HAPUS ORDER (sudah ada, tetap dipakai)
  void remove(String id) {
    final order = _orders.firstWhere(
      (e) => e.id == id,
      orElse:
          () => Order(id: '', customer: '', date: DateTime.now(), items: []),
    );
    if (order.id.isEmpty) return;

    for (final it in order.items) {
      final prod = inventory.items.firstWhere(
        (p) => p.id == it.productId,
        orElse:
            () => Product(
              id: '',
              name: '',
              category: '',
              unit: '',
              price: 0,
              stockQty: 0,
            ),
      );
      if (prod.id.isEmpty) continue;

      if (prod.isMenu) {
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
