import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../util/database_helper.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/product.dart';
import 'inventory_controller.dart';

class OrderController extends ChangeNotifier {
  final InventoryController inventory;
  OrderController(this.inventory) {
    _load();
  }

  final List<Order> _orders = [];
  List<Order> get items => List.unmodifiable(_orders);

  // ── load dari SQLite
  Future<void> _load() async {
    final rows = await DBHelper.getOrders();
    _orders.clear();
    for (final o in rows) {
      final itemsRaw = await DBHelper.getOrderItems(o['id']);
      final it = itemsRaw.map(OrderItem.fromMap).toList();
      _orders.add(Order.fromMap(o, it));
    }
    notifyListeners();
  }

  // ── buat order kosong
  Future<String> addNew(String customer) async {
    final id = const Uuid().v4();
    final dateIso = DateTime.now().toIso8601String();
    await DBHelper.insertOrder(id, customer, dateIso);
    _orders.add(
      Order(id: id, customer: customer, date: DateTime.now(), items: []),
    );
    notifyListeners();
    return id;
  }

  // ── tambah item dgn sink stok & DB
  Future<bool> addItem(String orderId, OrderItem item) async {
    final order = _orders.firstWhere(
      (o) => o.id == orderId,
      orElse:
          () => Order(id: '', customer: '', date: DateTime.now(), items: []),
    );
    if (order.id.isEmpty) return false;

    final prod = inventory.items.firstWhere(
      (p) => p.id == item.productId,
      orElse: () => Product.empty(),
    );
    if (prod.id.isEmpty) return false;

    // stok check
    if (prod.isMenu) {
      if (!await inventory.consumeRecipe(prod.recipe!, item.qty)) return false;
    } else {
      if (!await inventory.adjustStock(item.productId, -item.qty)) return false;
    }

    await DBHelper.insertOrderItem(
      orderId,
      item.productId,
      item.qty,
      item.unitPrice,
    );
    order.items.add(item);
    notifyListeners();
    return true;
  }

  // ── hapus order (DBHelper sudah cascade)
  Future<void> remove(String id) async {
    await DBHelper.deleteOrder(id);
    _orders.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
