import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';

class InventoryController extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  void add({
    required String name,
    required String category,
    required String unit,
    required double price,
    required int stockQty,
    int minStock = 0,
  }) {
    final product = Product(
      id: const Uuid().v4(),
      name: name,
      category: category,
      unit: unit,
      price: price,
      stockQty: stockQty,
      minStock: minStock,
    );
    _items.add(product);
    notifyListeners();
  }

  void update(Product updated) {
    final index = _items.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _items[index] = updated;
      notifyListeners();
    }
  }

  void adjustStock(String id, int delta) {
    final index = _items.indexWhere((p) => p.id == id);
    if (index != -1) {
      _items[index].stockQty = (_items[index].stockQty + delta).clamp(0, 999999);
      notifyListeners();
    }
  }

  void remove(String id) {
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
