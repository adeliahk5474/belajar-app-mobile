import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';

class OrderController extends ChangeNotifier {
  final InventoryController inventory;
  OrderController(this.inventory);

  final _orders = <Order>[];
  List<Order> get items => List.unmodifiable(_orders);

   /// tambahkan order & kurangi stok
  bool addOrder({
    required String customer,
    required List<OrderItem> items,
  }) {
    // cek stok cukup
    for (var i in items) {
      final p = inventory.items.firstWhere((e) => e.id == i.productId);
      if (p.stockQty < i.qty) return false; // stok kurang, batalkan
    }

    // stok cukup → kurangi
    for (var i in items) {
      inventory.adjustStock(i.productId, -i.qty);
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

  void remove(String id) => _orders.removeWhere((o) => o.id == id);
}